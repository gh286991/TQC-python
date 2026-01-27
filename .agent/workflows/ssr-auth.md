---
description: Next.js SSR 認證與 API 調用最佳實踐
---

# Next.js SSR 認證最佳實踐

本 skill 涵蓋 Next.js 應用中 SSR（Server-Side Rendering）與客戶端的認證和 API 調用最佳實踐。

## 核心原則

### 1. 客戶端請求必須使用相對路徑

所有客戶端組件（`'use client'`）中的 API 請求必須使用**相對路徑**，通過 Next.js rewrites 代理到後端：

```typescript
// ✅ 正確 - 使用相對路徑通過代理
const res = await fetch("/api/users/profile", { credentials: "include" });

// ❌ 錯誤 - 直接請求後端 URL（跨域 cookie 問題）
const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_URL}/users/profile`);
```

**原因**：跨域請求無法正確傳送 `HttpOnly` cookie，即使設置 `credentials: 'include'`。

### 2. SSR 請求需要特殊處理

Server Components 在服務器端執行，需要：

1. 使用 `cookies()` 獲取 token
2. 手動傳遞 Cookie header
3. 使用內部後端 URL（避免繞遠路）

```typescript
// app/page.tsx (Server Component)
import { cookies } from "next/headers";

async function getData() {
  const cookieStore = await cookies();
  const token = cookieStore.get("jwt_token")?.value;

  if (!token) return { user: null };

  const headers = {
    "Content-Type": "application/json",
    Cookie: `jwt_token=${token}`, // 手動傳遞 cookie
  };

  // SSR 優先使用內部 URL
  const baseUrl =
    process.env.BACKEND_INTERNAL_URL ||
    process.env.NEXT_PUBLIC_BACKEND_URL ||
    "http://localhost:3001/api";

  const res = await fetch(`${baseUrl}/users/profile`, {
    headers,
    cache: "no-store",
  });

  return res.ok ? { user: await res.json() } : { user: null };
}
```

### 3. API Client 配置（Axios）

```typescript
// lib/apiClient.ts
import axios from "axios";

const apiClient = axios.create({
  baseURL: "/api", // ✅ 相對路徑
  withCredentials: true,
});

export default apiClient;
```

### 4. Next.js Rewrites 配置

```typescript
// next.config.ts
const nextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: `${process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:3001"}/:path*`,
      },
    ];
  },
};
```

## 環境變數配置

### 本地開發

```env
NEXT_PUBLIC_BACKEND_URL=http://localhost:3001/api
```

### 生產環境（Zeabur/Docker）

```env
# 公開 URL（用於 rewrites）
NEXT_PUBLIC_BACKEND_URL=http://backend:3001/api

# 內部 URL（用於 SSR，可選）
BACKEND_INTERNAL_URL=http://backend.zeabur.internal/api
```

## 常見問題排查

### 問題：401 Unauthorized

**症狀**：登入後 API 請求返回 401

**檢查項目**：

1. 是否使用相對路徑（`/api/...`）？
2. 是否設置 `credentials: 'include'`？
3. Next.js rewrites 是否正確配置？
4. 後端 CORS 是否允許前端域名？

### 問題：SSR 期間 Invalid URL

**症狀**：Build 時出現 `ERR_INVALID_URL` 或 DNS 錯誤

**原因**：SSR 使用相對路徑 `/api` 在服務器端無效

**解決**：

1. 為 SSR 頁面使用絕對 URL（`BACKEND_INTERNAL_URL`）
2. 或添加 `export const dynamic = 'force-dynamic'` 避免預渲染

### 問題：Cookie 未設置

**症狀**：登入成功但跳轉後無 cookie

**檢查項目**：

1. 後端 cookie 配置：`sameSite: 'none'`, `secure: true`
2. 前端是否同域（或通過代理）
3. OAuth callback 後的重定向是否正確
