---
name: diagnosing-bugs
description: Diagnose a reported bug, failing behavior, crash, or performance regression using a reproducible symptom and targeted evidence. Use for debugging, not routine feature implementation.
---

# Diagnosing bugs

Adapted from Matt Pocock's [`diagnosing-bugs`](https://github.com/mattpocock/skills/blob/main/skills/engineering/diagnosing-bugs/SKILL.md) skill. Keep the investigation evidence-led and proportionate to the impact and available feedback loop.

## Workflow

1. **Pin down the symptom.** Read the report and relevant project guidance.
   Identify the expected and actual behavior, affected path, and environment.
   Reuse existing scripts, logs, or fixtures. Do not add or run tests unless
   the user asks.
2. **Reproduce before changing code.** Build the narrowest reliable way to
   observe the reported problem. Confirm the observed failure is the one the
   user described. If reproduction is blocked, state what is missing instead
   of presenting a guess as a diagnosis.
3. **Reduce the problem.** Remove unrelated inputs or steps while preserving
   the failure. This narrows the possible causes and makes the eventual fix
   easier to verify.
4. **Rank falsifiable explanations.** State a small number of plausible causes
   and what evidence would support or rule out each. Investigate one variable at
   a time using targeted inspection or instrumentation.
5. **Fix the cause, then recheck the symptom.** Keep the patch focused. Re-run
   the same reproduction path and appropriate non-test checks. Add or run
   tests only when the user requests them.
6. **Clean up.** Remove temporary logging and throwaway artifacts. Summarize
   the confirmed cause, fix, evidence, and remaining uncertainty.

## Constraints

- Never print secrets or unredacted credentials from logs or captured output.
- For performance regressions, collect a comparable baseline before optimizing
  and measure the same scenario after the change. Do not claim improvement from
  code inspection alone.
- For React Native live UI reproduction or inspection, follow `expo-mobile` and
  use `agent-device` with the applicable platform skill. Use the configured E2E
  runner only when the user asks for repeatable-flow verification.
- Do not broaden a bug fix into an unrelated refactor. Record a separate
  cleanup opportunity if the cause exposes a larger design concern.
