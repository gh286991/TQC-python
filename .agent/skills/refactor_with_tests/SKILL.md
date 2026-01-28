---
name: Refactor with Tests
description: A strict workflow for safe refactoring: List features, Write Tests, Pass Tests, Freeze Tests, Refactor, Verify.
---

# Refactor with Tests Skill

This skill defines a mandatory workflow for refactoring code (components, pages, logic) to ensure functional consistency and prevent regressions.

## Workflow Steps

### 1. 📝 Analysis & Listing (Pre-Work)

**Before writing any code or tests:**

1.  **Identify the Target**: Explicitly state which file(s), component(s), or page(s) will be refactored.
2.  **List Features & Behaviors**: Create a bulleted list of all features, user interactions, and logic flows that the target currently supports.
    - Include "Happy Paths" (normal usage).
    - Include "Edge Cases" (errors, empty states, loading states).
3.  **Output**: A planned list of functionality to be preserved.

### 2. 🧪 Test Creation (The Safety Net)

**Before modifying the target code:**

1.  **Write Tests**: Create comprehensive tests (Unit, Integration, or E2E) for _every_ item in your feature list.
    - Use the existing testing framework of the project (e.g., Jest, Vitest, Playwright, Python unittest).
    - Aim for maximum coverage of the flows.
2.  **Verify Baseline**: Run these new tests against the **EXISTING (OLD)** code.
    - **CRITICAL**: All tests MUST PASS before you proceed.
    - If a test fails, it means either the test is incorrect or the existing code has a bug. Resolve this first.
    - _Do not start refactoring until you have a green test suite._

### 3. 🔒 Test Freeze

**Once tests pass against the old code:**

1.  **Freeze the Tests**: You are strictly **FORBIDDEN** from modifying the test files during the refactoring phase.
2.  **Source of Truth**: These tests now define the "correct behavior". If the refactored code fails a test, the _code_ is wrong, not the test.

### 4. ♻️ Refactoring

1.  **Execute Refactor**: Perform the code structure changes, cleanups, or optimizations.
2.  **Run Tests Frequently**: Run the frozen test suite often ensuring you haven't broken anything.

### 5. ✅ Verification & Completion

1.  **Refactor Until Green**: Continue working on the code until ALL frozen tests pass.
2.  **No Regressions**: Confirm that no existing functionality was lost.
3.  **Code Review**: Ensure the new code meets quality standards.

## Usage Example

When asked to refactor a component:

1.  **Don't** just start editing the component.
2.  **Do** read this skill.
3.  **Do** create a reproduction/test case that passes.
4.  Then refactor.
