{ ... }:
{
  flake.modules.homeManager.claudeConfig =
    { ... }:
    {
      home.file.".claude/skills/handoff/SKILL.md" = {
        text = ''
          ---
          name: handoff
          description: Write or update a handoff document so the next agent with fresh context can continue this work.
          ---

          Write or update a handoff document so the next agent with fresh context can continue this work.

          Steps:
          1. Check if HANDOFF.md already exists in the project
          2. If it exists, read it first to understand prior context before updating
          3. Create or update the document with:
             - **Goal**: What we're trying to accomplish
             - **Current Progress**: What's been done so far — summarize older history heavily, focus on immediate context
             - **What Worked**: Approaches that succeeded
             - **What Didn't Work**: Approaches that were wrong or ineffective (so they're not repeated)
             - **Blockers**: Things blocked by external factors (missing API access, waiting on someone, etc.)
             - **Relevant Files**: Exact file paths that were recently edited or are needed for next steps
             - **Next Steps**: Clear action items for continuing

          Keep the document concise. If it already exists, compress older progress into a single summary line — don't let it grow unbounded.

          Save as HANDOFF.md in the project root and tell the user the file path so they can start a fresh conversation with just that path.
        '';
      };

      home.file.".claude/skills/from-handoff/SKILL.md" = {
        text = ''
          ---
          name: from-handoff
          description: Resume work from a HANDOFF.md file at the start of a new session.
          ---

          Resume work from a HANDOFF.md file.

          Steps:
          1. Find HANDOFF.md in the current project root
          2. If not found, tell the user and stop
          3. Read it carefully: goal, progress, what worked, what didn't, blockers, relevant files, next steps
          4. Verify current state: briefly read the key files listed under Relevant Files to confirm they match what HANDOFF.md describes
          5. Tell the user in 2-3 sentences where things stand and what you'll work on next
          6. If the first next step involves irreversible operations (file deletion, git push, database changes, etc.), ask the user to confirm before proceeding
          7. Otherwise proceed with the first next step
        '';
      };

      home.file.".claude/skills/improve-codebase-architecture/SKILL.md" = {
        text = ''
          ---
          name: improve-codebase-architecture
          description: Surface architectural friction and propose deepening opportunities — refactors that convert shallow modules into deep ones, improving testability and AI-navigability.
          ---

          # Improve Codebase Architecture - SKILL.md

          This skill helps teams surface architectural friction and propose **deepening opportunities**—refactors that convert shallow modules into deep ones, improving testability and AI-navigability.

          ## Core Vocabulary

          The skill enforces consistent terminology across all suggestions:

          - **Module**: any unit with interface + implementation (function, class, package)
          - **Interface**: everything callers must know—types, invariants, error modes, ordering
          - **Depth**: leverage at the interface; "deep" means high behavior-to-interface ratio
          - **Seam**: where an interface lives; a place to alter behavior without editing in place
          - **Adapter**: concrete implementation of an interface at a seam
          - **Locality**: benefit maintainers gain when bugs and changes concentrate in one place

          Key test: imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity spreads across multiple callers, it was earning its keep.

          ## Three-Phase Process

          **1. Explore** — Read `CONTEXT.md` and relevant ADRs first, then use the Agent tool to walk the codebase organically, identifying friction points where understanding requires bouncing between many small modules or where interfaces nearly match their implementations in complexity.

          **2. Present Candidates** — List deepening opportunities with files involved, the problem, plain-English solution, and benefits framed around locality and leverage. Use domain vocabulary from `CONTEXT.md` and architectural language from the skill's glossary. Don't propose interfaces yet; ask which candidates interest the user.

          **3. Grilling Loop** — Once the user selects a candidate, explore design trade-offs together. Update `CONTEXT.md` as new domain terms emerge. Offer ADRs only when rejection reasons would prevent future re-suggestion of the same candidate.
        '';
      };

      home.file.".claude/skills/improve-codebase-architecture/DEEPENING.md" = {
        text = ''
          # Deepening

          How to deepen a cluster of shallow modules safely, given its dependencies. Assumes the vocabulary in [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**.

          ## Dependency categories

          When assessing a candidate for deepening, classify its dependencies. The category determines how the deepened module is tested across its seam.

          ### 1. In-process

          Pure computation, in-memory state, no I/O. Always deepenable — merge the modules and test through the new interface directly. No adapter needed.

          ### 2. Local-substitutable

          Dependencies that have local test stand-ins (PGLite for Postgres, in-memory filesystem). Deepenable if the stand-in exists. The deepened module is tested with the stand-in running in the test suite. The seam is internal; no port at the module's external interface.

          ### 3. Remote but owned (Ports & Adapters)

          Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. The deep module owns the logic; the transport is injected as an **adapter**. Tests use an in-memory adapter. Production uses an HTTP/gRPC/queue adapter.

          Recommendation shape: *"Define a port at the seam, implement an HTTP adapter for production and an in-memory adapter for testing, so the logic sits in one deep module even though it's deployed across a network."*

          ### 4. True external (Mock)

          Third-party services (Stripe, Twilio, etc.) you don't control. The deepened module takes the external dependency as an injected port; tests provide a mock adapter.

          ## Seam discipline

          - **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a port unless at least two adapters are justified (typically production + test). A single-adapter seam is just indirection.
          - **Internal seams vs external seams.** A deep module can have internal seams (private to its implementation, used by its own tests) as well as the external seam at its interface. Don't expose internal seams through the interface just because tests use them.

          ## Testing strategy: replace, don't layer

          - Old unit tests on shallow modules become waste once tests at the deepened module's interface exist — delete them.
          - Write new tests at the deepened module's interface. The **interface is the test surface**.
          - Tests assert on observable outcomes through the interface, not internal state.
          - Tests should survive internal refactors — they describe behaviour, not implementation. If a test has to change when the implementation changes, it's testing past the interface.
        '';
      };

      home.file.".claude/skills/improve-codebase-architecture/INTERFACE-DESIGN.md" = {
        text = ''
          # Interface Design

          When the user wants to explore alternative interfaces for a chosen deepening candidate, use this parallel sub-agent pattern. Based on "Design It Twice" (Ousterhout) — your first idea is unlikely to be the best.

          Uses the vocabulary in [LANGUAGE.md](LANGUAGE.md) — **module**, **interface**, **seam**, **adapter**, **leverage**.

          ## Process

          ### 1. Frame the problem space

          Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

          - The constraints any new interface would need to satisfy
          - The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
          - A rough illustrative code sketch to ground the constraints — not a proposal, just a way to make the constraints concrete

          Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

          ### 2. Spawn sub-agents

          Spawn 3+ sub-agents in parallel using the Agent tool. Each must produce a **radically different** interface for the deepened module.

          Prompt each sub-agent with a separate technical brief (file paths, coupling details, dependency category from [DEEPENING.md](DEEPENING.md), what sits behind the seam). The brief is independent of the user-facing problem-space explanation in Step 1. Give each agent a different design constraint:

          - Agent 1: "Minimize the interface — aim for 1–3 entry points max. Maximise leverage per entry point."
          - Agent 2: "Maximise flexibility — support many use cases and extension."
          - Agent 3: "Optimise for the most common caller — make the default case trivial."
          - Agent 4 (if applicable): "Design around ports & adapters for cross-seam dependencies."

          Include both [LANGUAGE.md](LANGUAGE.md) vocabulary and CONTEXT.md vocabulary in the brief so each sub-agent names things consistently with the architecture language and the project's domain language.

          Each sub-agent outputs:

          1. Interface (types, methods, params — plus invariants, ordering, error modes)
          2. Usage example showing how callers use it
          3. What the implementation hides behind the seam
          4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
          5. Trade-offs — where leverage is high, where it's thin

          ### 3. Present and compare

          Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

          After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu.
        '';
      };

      home.file.".claude/skills/improve-codebase-architecture/LANGUAGE.md" = {
        text = ''
          # Language

          Shared vocabulary for every suggestion this skill makes. Use these terms exactly — don't substitute "component," "service," "API," or "boundary." Consistent language is the whole point.

          ## Terms

          **Module**
          Anything with an interface and an implementation. Deliberately scale-agnostic — applies equally to a function, class, package, or tier-spanning slice.
          _Avoid_: unit, component, service.

          **Interface**
          Everything a caller must know to use the module correctly. Includes the type signature, but also invariants, ordering constraints, error modes, required configuration, and performance characteristics.
          _Avoid_: API, signature (too narrow — those refer only to the type-level surface).

          **Implementation**
          What's inside a module — its body of code. Distinct from **Adapter**: a thing can be a small adapter with a large implementation (a Postgres repo) or a large adapter with a small implementation (an in-memory fake). Reach for "adapter" when the seam is the topic; "implementation" otherwise.

          **Depth**
          Leverage at the interface — the amount of behaviour a caller (or test) can exercise per unit of interface they have to learn. A module is **deep** when a large amount of behaviour sits behind a small interface. A module is **shallow** when the interface is nearly as complex as the implementation.

          **Seam** _(from Michael Feathers)_
          A place where you can alter behaviour without editing in that place. The *location* at which a module's interface lives. Choosing where to put the seam is its own design decision, distinct from what goes behind it.
          _Avoid_: boundary (overloaded with DDD's bounded context).

          **Adapter**
          A concrete thing that satisfies an interface at a seam. Describes *role* (what slot it fills), not substance (what's inside).

          **Leverage**
          What callers get from depth. More capability per unit of interface they have to learn. One implementation pays back across N call sites and M tests.

          **Locality**
          What maintainers get from depth. Change, bugs, knowledge, and verification concentrate at one place rather than spreading across callers. Fix once, fixed everywhere.

          ## Principles

          - **Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small, mockable, swappable parts — they just aren't part of the interface. A module can have **internal seams** (private to its implementation, used by its own tests) as well as the **external seam** at its interface.
          - **The deletion test.** Imagine deleting the module. If complexity vanishes, the module wasn't hiding anything (it was a pass-through). If complexity reappears across N callers, the module was earning its keep.
          - **The interface is the test surface.** Callers and tests cross the same seam. If you want to test *past* the interface, the module is probably the wrong shape.
          - **One adapter means a hypothetical seam. Two adapters means a real one.** Don't introduce a seam unless something actually varies across it.

          ## Relationships

          - A **Module** has exactly one **Interface** (the surface it presents to callers and tests).
          - **Depth** is a property of a **Module**, measured against its **Interface**.
          - A **Seam** is where a **Module**'s **Interface** lives.
          - An **Adapter** sits at a **Seam** and satisfies the **Interface**.
          - **Depth** produces **Leverage** for callers and **Locality** for maintainers.

          ## Rejected framings

          - **Depth as ratio of implementation-lines to interface-lines** (Ousterhout): rewards padding the implementation. We use depth-as-leverage instead.
          - **"Interface" as the TypeScript `interface` keyword or a class's public methods**: too narrow — interface here includes every fact a caller must know.
          - **"Boundary"**: overloaded with DDD's bounded context. Say **seam** or **interface**.
        '';
      };
    };
}
