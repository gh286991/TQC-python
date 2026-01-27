---
description: Use pnpm for package management
---

# pnpm Installation Workflow

// turbo-all

1. When installing packages, always use `pnpm add [package]`.
2. When running scripts, use `pnpm run [script]`.
3. For one-off commands (like npx), use `pnpm dlx [command]`.

Example:

```bash
pnpm add @radix-ui/react-dialog
pnpm dlx shadcn@latest add dialog
nvm use 24 && pnpm dev
```
