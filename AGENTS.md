# Spec Driven Development Rules

All agents must follow OpenSpec workflows.

Default lifecycle:
1. NEVER implement code directly from chat.
2. Always start with openspec-new-change when a feature or change is requested.
3. Update markdown specs BEFORE touching source code.
4. Source code changes only happen via openspec-apply-change workflow.
5. Every completed change must be archived using openspec-archive-change.

Behavior:
- If a user asks for a feature, treat it as an implicit openspec-new-change request.
- Refuse direct implementation if no OpenSpec change exists.

Architecture Context:
- This is an SDK-first Flutter monorepo.
- packages/core is the platform SDK (design, accessibility, navigation).
- packages/courses and packages/exams are domain packages.
- app is only the consumer shell.
- Distributed docs inside packages/*/docs are source context.

Guardrails:
- Do NOT move existing files.
- Do NOT redesign architecture during onboarding.
- Use existing ADRs and markdown as context.

Implementation rules and UI constraints are defined in:
packages/core/docs/ai_context.md

Agents MUST respect those rules during implementation phases.

Commit bodies must be short and scannable.

- Explain intent naturally.
- Use 1–3 short lines.
- Prefer simple sentences over long paragraphs.
- Avoid prefixes like "Why:" or academic explanations.
