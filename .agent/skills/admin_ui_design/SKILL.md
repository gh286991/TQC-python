---
name: Admin UI/UX 設計準則
description: 建立高級、現代化且一致的 Admin 介面的設計指南（TailwindCSS、Glassmorphism、Dark Mode、可用性優先）。
---

# Admin UI/UX 設計準則

本技能文檔定義 Admin 後台的設計系統與程式碼規範。目標是 **一致、可維護、可擴充、可用性高**，並維持「現代深色毛玻璃」質感。

---

## 0. 設計哲學（先決規則）

1. **可用性 > 視覺特效**：毛玻璃只能「點綴」，不能犧牲可讀性與操作效率。
2. **一致性 > 創意**：同一種資訊/操作在所有頁面都用同樣模式呈現。
3. **資訊層級清楚**：頁面標題、主要操作、次要操作、內容區塊、狀態訊息要一眼分層。
4. **狀態完整**：Loading / Empty / Error / Disabled / Hover / Focus / Selected 必須都有設計。
5. **可達性不可省**：對比度、鍵盤操作、ARIA、焦點圈必須可見。

---

## 1. Design Tokens（全站統一的「設計參數」）

> 以 Tailwind utility 為主，不自訂大量 CSS。允許用 `cn()` 組 class 組合。

### 色彩（Color）

- **App 背景**：`bg-slate-950`
- **Sidebar 背景**：`bg-slate-900 border-r border-slate-800`
- **Surface/卡片底**：`bg-white/5 border border-white/10 backdrop-blur-xl`
- **Surface 強化（更突出）**：`bg-slate-900/40 border-white/10`
- **文字**
  - 主文字：`text-slate-100`
  - 內容文字：`text-slate-200`
  - 次要文字：`text-slate-400`
  - 禁用/提示：`text-slate-500`
- **強調色（Accent）**：藍 / 靛 / 紫（用於主要 CTA 與關鍵狀態）
  - 常用漸層：`from-blue-600 to-indigo-600`、`from-indigo-600 to-purple-600`

### 圓角與陰影（Radius & Shadow）

- 卡片：`rounded-2xl`
- 控制元件（input/button）：`rounded-xl`
- 陰影：`shadow-xl`（不要過多，避免髒）

### 間距與尺寸（Spacing & Sizing）

- 頁面內距：`p-6 md:p-8`
- 區塊間距：`gap-6`
- 標題區塊與內容：`mb-8`
- 表單欄位間距：`gap-4`

### 動畫（Motion）

- 全站互動：`transition-all duration-300`
- 頁面進場：`animate-in fade-in slide-in-from-bottom-4 duration-300`
- **禁忌**：不要在表格每列 hover 都做太重動畫（會很暈）

---

## 2. Layout 架構（後台的基本骨架）

### Sidebar

- 固定寬：`w-64`
- 內容：Logo / 主選單 / 次選單 / 使用者區
- 選單 item
  - 預設：`text-slate-300 hover:text-white hover:bg-white/5`
  - Active：`bg-white/10 text-white border border-white/10`

### Content Area

- 頁面容器：`min-h-screen bg-slate-950`
- 內容寬度：預設全寬，必要時用 `max-w-7xl mx-auto`

### Page Structure（每頁固定版型）

1. **Header**：標題 + 副標 + 主要 CTA（例如「新增題目」）
2. **Toolbar**：搜尋、篩選、排序、批次操作（表格頁必備）
3. **Content**：卡片/表格/表單
4. **Footer（可選）**：分頁、總筆數、快捷操作

---

## 3. 元件規範（Component Spec）

### 3.1 Glass Card（通用容器）

```tsx
<div className="relative rounded-2xl bg-white/5 border border-white/10 backdrop-blur-xl shadow-xl p-6 transition-all duration-300 hover:border-white/20">
  {/* content */}
</div>
```

### 3.2 Buttons（按鈕系統）

> 後台按鈕必須有層級：Primary / Secondary / Ghost / Danger

- **Primary（主要動作，整頁最多 1 個）**
  - `bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg shadow-blue-500/25 hover:from-blue-500 hover:to-indigo-500`
- **Secondary（次要動作）**
  - `bg-white/10 hover:bg-white/15 text-slate-100 border border-white/10`
- **Ghost（工具列、次要操作）**
  - `bg-transparent hover:bg-white/5 text-slate-300 hover:text-white`
- **Danger（刪除、不可逆）**
  - `bg-gradient-to-r from-rose-600 to-red-600 text-white shadow-lg shadow-red-500/20 hover:from-rose-500 hover:to-red-500`

共同規則：

- 高度：`h-10`（工具列）/ `h-11`（表單 CTA）
- 內距：`px-4`
- Focus：一定要 `focus-visible:ring-2 focus-visible:ring-blue-500/40`

### 3.3 Inputs（輸入框系統）

- Base
  - `h-11 w-full rounded-xl bg-slate-900/50 border border-white/10 text-slate-200 placeholder:text-slate-600`
  - Focus：`focus:border-blue-500/50 focus:ring-2 focus:ring-blue-500/20`
- 帶 icon 的輸入框
  - 容器 `relative`
  - icon `absolute left-3 top-1/2 -translate-y-1/2 text-slate-500`
  - input 加 `pl-10`

狀態規則（一定要做到）：

- Error：邊框變紅 + 提示文字（`text-rose-400`）
- Disabled：`opacity-60 cursor-not-allowed`
- Loading：input 右側顯示 spinner（避免整頁 loading）

### 3.4 Badges / Status Pills（狀態膠囊）

用途：顯示「啟用/停用」「草稿/發布」「難度」「權限」等。

- 外觀：`px-2.5 py-1 rounded-full text-xs border`
- 依狀態使用不同 accent（但保持低飽和，避免花）

### 3.5 Table（後台最核心）

表格頁必備元素：

1. 欄位：清楚、可排序（有排序 icon）
2. Toolbar：搜尋、篩選、批次操作
3. Row actions：避免每列塞滿按鈕，建議 `...` menu
4. 分頁：底部固定區塊
5. 狀態：Loading skeleton / Empty state / Error state

表格視覺：

- Header：`text-slate-300 bg-white/5`
- Row hover：`hover:bg-white/5`
- 分隔線：`border-white/10`

### 3.6 Modal / Dialog（重要操作）

規則：

- 只用在「需要專注」或「不可逆確認」
- 必須支援 ESC、點背景關閉（除非危險操作）
- Danger 操作要有明確文案（例如「此操作無法復原」）

---

## 4. Typography（排版規範）

- 字體：Inter / system-ui
- H1（頁面標題）：`text-3xl font-bold tracking-tight`
  - 漸層標題：`bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent`
- 副標：`text-slate-400`
- 區塊標題（Card title）：`text-slate-100 font-semibold`
- 說明文字：`text-slate-400 text-sm`

---

## 5. 互動與狀態（UX 必做清單）

每個頁面/元件至少要有：

- **Loading**：Skeleton（表格、卡片、表單都要）
- **Empty**：引導行為（例如「建立第一筆題目」按鈕）
- **Error**：可重試（Retry）+ 錯誤摘要
- **Success**：Toast（不要用 alert 阻塞）
- **Disabled**：文案提示原因（例如「請先選擇至少一筆」）

---

## 6. Page Header 範本（統一頁首）

```tsx
<div className="flex items-start justify-between gap-4 mb-8">
  <div className="flex flex-col gap-2">
    <h1 className="text-3xl font-bold tracking-tight bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent">
      頁面標題
    </h1>
    <p className="text-slate-400">解釋該頁面功能的描述性副標題。</p>
  </div>

  <div className="flex items-center gap-2">
    {/* Secondary / Ghost */}
    <button className="h-10 px-4 rounded-xl bg-white/10 hover:bg-white/15 text-slate-100 border border-white/10 transition-all duration-300">
      次要操作
    </button>

    {/* Primary CTA */}
    <button className="h-10 px-4 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white shadow-lg shadow-blue-500/25 transition-all duration-300">
      主要操作
    </button>
  </div>
</div>
```

---

## 7. 開發規範（Implementation Rules）

1. **Tailwind 優先**：不要為了小差異狂加 CSS 檔。
2. **Class 組合**：用 `cn()`（或同等）統一管理 variant。
3. **Lucide Icons**：全站一致使用 `lucide-react`。
4. **響應式**：內容區塊用 `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`；表格在小螢幕要提供替代呈現（卡片列表或水平捲動）。
5. **可達性**
   - 所有可點元素要能 tab 到
   - `focus-visible:ring-*` 必備
   - icon button 要有 `aria-label`
6. **一致命名**
   - 元件：`<PageHeader />`, `<Toolbar />`, `<DataTable />`, `<EmptyState />`, `<Skeleton />`
7. **不要亂用顏色**
   - 除了狀態（success/warn/error）與主要 CTA，其他都走 slate 系列
8. **資訊密度可控**
   - 表格預設顯示最關鍵欄位，其他放到展開/詳情頁

---

## 8. 背景 Blob（裝飾用，但不可影響可讀性）

- 放在頁面最底層，`pointer-events-none`、`opacity-20` 以下
- 避免在表格頁過強（會干擾掃讀）
