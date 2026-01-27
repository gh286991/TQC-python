# Quality Check Skill

Description: Verify project health by checking backend and frontend for TypeScript errors, ESLint issues, and terminal stability.

## Instructions

After completing any significant code changes or feature implementation, perform the following checks:

1.  **Backend Quality Check**
    - Run `cd backend && pnpm exec tsc --noEmit` to check for TypeScript compilation errors.
    - Run `cd backend && pnpm run lint` to check for ESLint issues and auto-fix where possible.
    - If errors persist, fix them manually.

2.  **Frontend Quality Check**
    - Run `cd frontend && pnpm exec tsc --noEmit` to check for TypeScript compilation errors.
    - Run `cd frontend && pnpm run lint` to check for ESLint issues.
    - If errors persist, fix them manually (e.g., using `pnpm run lint --fix` if available).

3.  **Terminal Health Check**
    - Check running terminals (e.g., `pnpm dev`, `pnpm start`) for any runtime errors, crashes, or warnings.
    - Ensure both backend and frontend services remain responsive after changes.
