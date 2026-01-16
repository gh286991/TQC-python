# 🐍 TQC Python Mock Exam Platform

一個基於 AI 生成題目的 TQC Python 模擬考試練習平台。使用 Google Gemini API 動態生成題目，並提供線上程式碼編輯器與即時執行環境。

![Platform Screenshot](https://via.placeholder.com/800x450?text=Platform+Preview)

## ✨ 特色功能

- **🤖 AI 題目生成**：利用 Google Gemini 模型，根據 TQC Python 的九大類別動態生成練習題。
- **📝 線上程式碼編輯器**：整合 Monaco Editor，提供語法高亮、自動補全等 IDE 級體驗。
- **⚡️ 即時程式碼執行**：後端沙箱執行 Python 程式碼，並驗證輸出結果是否符合測資。
- **🎨 現代化 UI 設計**：
  - **Dark Mode**：全域深色主題，適合長時間 coding。
  - **Resizable Layout**：可自由拖拉調整「題目」、「編輯器」、「執行結果」的版面比例。
  - **Glassmorphism**：精緻的毛玻璃視覺效果。

## 🛠️ 技術架構

本專案採用 Monorepo 架構：

- **Frontend**: [Next.js 15](https://nextjs.org/) (React), Tailwind CSS v4, Lucide Icons
- **Backend**: [NestJS](https://nestjs.com/), Mongoose
- **Database**: MongoDB (via Docker)
- **AI**: Google Gemini API
- **Package Manager**: pnpm

## 🚀 快速開始

### 1. 環境需求

- Node.js (v18+)
- pnpm (`npm install -g pnpm`)
- Docker (用於啟動 MongoDB)
- Google Gemini API Key

### 2. 安裝依賴

在專案根目錄執行：

```bash
pnpm install
```

### 3. 設定環境變數

1. 複製後端範例設定檔（如果有）或直接建立 `backend/.env`。
2. 填入您的 Gemini API Key：

```env
# backend/.env
GEMINI_API_KEY=your_api_key_here
```

### 4. 啟動資料庫

使用 Docker Compose 啟動 MongoDB：

```bash
docker-compose up -d
```

### 5. 啟動開發伺服器

同時啟動前端與後端：

```bash
pnpm dev
```

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001

## 📂 專案結構

```
.
├── backend/            # NestJS 後端應用
│   ├── src/
│   │   ├── gemini/    # Gemini AI 整合服務
│   │   ├── questions/ # 題目管理模組
│   │   └── execution/ # 程式碼執行模組
│   └── ...
├── frontend/           # Next.js 前端應用
│   ├── app/           # App Router 頁面
│   └── ...
├── docker-compose.yml  # MongoDB 服務定義
├── pnpm-workspace.yaml # Monorepo 設定
└── ...
```

## 📝 開發筆記

- **Git 分支**: 主分支為 `master`。
- **Python 執行**: 後端預設使用系統的 `python3` 指令執行使用者提交的程式碼，請確保伺服器環境已安裝 Python。

## 📄 License

MIT
