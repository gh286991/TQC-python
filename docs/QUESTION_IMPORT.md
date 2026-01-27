# 題目匯入格式文檔

本文檔說明如何創建和匯入題目到 TQC Python 考試平台。

## 目錄

- [基本結構](#基本結構)
- [欄位說明](#欄位說明)
- [檔案資源支援](#檔案資源支援)
- [匯入方式](#匯入方式)
- [完整範例](#完整範例)
- [最佳實踐](#最佳實踐)

---

## 基本結構

每個題目的 JSON 格式包含以下核心欄位:

```typescript
{
  "title": string,              // 題目標題 (必填)
  "description": string,        // 題目描述 (必填)
  "difficulty": string,         // 難度: "easy" | "medium" | "hard" (選填,預設 "medium")
  "samples": Sample[],          // 範例測試案例 (必填,至少1個)
  "testCases": TestCase[],      // 隱藏測試案例 (必填,至少1個)
  "referenceCode": string,      // 參考解答 (必填)
  "fileAssets": object,         // 全域檔案資源 (選填)
  "tags": string[],             // 分類標籤 (選填)
  "constraints": string,        // 額外限制說明 (選填)
  "category": string            // 類別 (選填)
}
```

---

## 欄位說明

### 1. 基本資訊

#### `title` (必填)

- **類型**: `string`
- **說明**: 題目標題,應簡潔明確
- **範例**: `"Log 檔案分析"`, `"質數判斷"`, `"矩陣轉置"`

#### `description` (必填)

- **類型**: `string`
- **說明**: 題目描述,包含問題說明、輸入輸出格式、範例等
- **支援**: Markdown 格式
- **範例**:

  ```
  ## 問題描述
  請撰寫程式讀取 server.log 檔案,統計檔案中 ERROR 和 INFO 的出現次數。

  ## 輸入格式
  從 server.log 檔案讀取日誌內容

  ## 輸出格式
  ERROR count: X
  INFO count: Y
  ```

#### `difficulty` (選填)

- **類型**: `"easy" | "medium" | "hard"`
- **預設值**: `"medium"`
- **說明**: 題目難度等級

#### `category` (選填)

- **類型**: `string`
- **說明**: 題目所屬類別,如果不提供會使用匯入時的 category
- **範例**: `"file-io"`, `"string-manipulation"`

#### `tags` (選填)

- **類型**: `string[]`
- **說明**: 題目標籤,用於分類和搜尋
- **範例**: `["檔案讀寫", "字串處理", "迴圈"]`

---

### 2. 測試案例

#### `samples` (必填)

- **類型**: `Sample[]`
- **說明**: 顯示給使用者的範例測試案例
- **建議數量**: 1-5 個
- **用途**: 本地 Pyodide 執行時使用

**Sample 結構:**

```typescript
{
  "input": string,              // 輸入資料或描述
  "output": string,             // 預期輸出
  "explanation": string,        // 解釋說明 (選填)
  "fileAssets": {               // 檔案資源 (選填)
    "filename": "content"
  }
}
```

**範例:**

```json
{
  "input": "server.log: [INFO] System started",
  "output": "ERROR count: 0\nINFO count: 1",
  "fileAssets": {
    "server.log": "[INFO] System started"
  }
}
```

#### `testCases` (必填)

- **類型**: `TestCase[]`
- **說明**: 隱藏測試案例,用於評分
- **建議數量**: 10-20 個,包含邊界條件和特殊情況
- **用途**: 遠端 Piston 執行時使用

**TestCase 結構:**

```typescript
{
  "input": string,              // 輸入資料或描述
  "output": string,             // 預期輸出
  "type": string,               // 測試類型 (選填): "basic" | "edge" | "boundary"
  "description": string,        // 測試描述 (選填)
  "fileAssets": {               // 檔案資源 (選填)
    "filename": "content"
  }
}
```

**範例:**

```json
{
  "input": "server.log: [ERROR] Failed\n[INFO] Retry",
  "output": "ERROR count: 1\nINFO count: 1",
  "type": "basic",
  "description": "基本混合日誌測試",
  "fileAssets": {
    "server.log": "[ERROR] Failed\n[INFO] Retry"
  }
}
```

---

### 3. 參考解答

#### `referenceCode` (必填)

- **類型**: `string`
- **說明**: Python 參考解答程式碼
- **要求**: 必須能通過所有 testCases

**範例:**

```json
{
  "referenceCode": "error_count = 0\ninfo_count = 0\nwith open('server.log', 'r') as f:\n    for line in f:\n        if 'ERROR' in line:\n            error_count += 1\n        if 'INFO' in line:\n            info_count += 1\nprint(f\"ERROR count: {error_count}\")\nprint(f\"INFO count: {info_count}\")"
}
```

---

## 檔案資源支援

本平台支援三個層級的檔案資源定義,用於檔案 I/O 題目:

### 優先順序

1. **Sample/TestCase 層級** (最高優先度)
   - 定義在個別 sample 或 testCase 的 `fileAssets`
   - 用於每個測試案例需要不同檔案內容的情況

2. **Question 層級** (中優先度)
   - 定義在 question 的全域 `fileAssets`
   - 用於所有測試案例共用相同檔案的情況

3. **Legacy 格式** (向後相容,低優先度)
   - 從 `input` 字串解析 `filename: content` 格式
   - 不建議使用,僅為向後相容保留

### 使用方式

#### 方式一:個別 TestCase 的 fileAssets (推薦)

```json
{
  "testCases": [
    {
      "input": "",
      "output": "ERROR count: 0\nINFO count: 0",
      "fileAssets": {
        "server.log": ""
      }
    },
    {
      "input": "",
      "output": "ERROR count: 2\nINFO count: 3",
      "fileAssets": {
        "server.log": "[ERROR] Failed\n[INFO] Started\n[ERROR] Retry\n[INFO] Success\n[INFO] Done"
      }
    }
  ]
}
```

#### 方式二:全域 fileAssets

```json
{
  "fileAssets": {
    "config.json": "{\"debug\": true}",
    "data.txt": "Hello World"
  },
  "testCases": [
    {
      "input": "",
      "output": "Debug: true"
    }
  ]
}
```

#### 方式三:Legacy 格式 (不推薦)

```json
{
  "testCases": [
    {
      "input": "data.txt: Hello World",
      "output": "Hello World"
    }
  ]
}
```

### 支援的檔案類型

- 純文字檔 (`.txt`, `.log`, `.csv`)
- 程式碼檔 (`.py`, `.js`, `.json`)
- 設定檔 (`.conf`, `.ini`, `.yaml`)
- 任何基於文字的檔案格式

---

## 匯入方式

### 方式一:透過 Web UI 匯入

1. 進入任意科目頁面 (例: `/subject/python-basic`)
2. 點擊「匯入 Mock Exam」按鈕
3. 選擇 JSON 檔案或 ZIP 壓縮檔
4. 系統會自動解析並匯入題目

### 方式二:透過 API 匯入

**Endpoint:** `POST /api/import/upload`

**Headers:**

```
Content-Type: multipart/form-data
Authorization: Bearer <token>
```

**Body (form-data):**

- `file`: JSON 或 ZIP 檔案
- `subjectId`: 科目 ID (選填)

**範例 (使用 curl):**

```bash
curl -X POST http://localhost:3001/api/import/upload \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -F "file=@exam-questions.json" \
  -F "subjectId=507f1f77bcf86cd799439011"
```

### ZIP 檔案結構

如果使用 ZIP 檔案匯入多個題目:

```
exam-package.zip
├── Q1.json
├── Q2.json
├── Q3.json
└── ...
```

每個 JSON 檔案應包含單一題目的完整定義。

---

## 完整範例

### 範例一:簡單的數學題

```json
{
  "title": "兩數相加",
  "description": "請撰寫程式讀取兩個整數 a 和 b,輸出它們的和。\n\n## 輸入格式\n兩個整數 a 和 b,以空格分隔\n\n## 輸出格式\na + b 的結果",
  "difficulty": "easy",
  "samples": [
    {
      "input": "3 5",
      "output": "8"
    },
    {
      "input": "10 20",
      "output": "30"
    }
  ],
  "testCases": [
    {
      "input": "0 0",
      "output": "0",
      "type": "edge",
      "description": "零值測試"
    },
    {
      "input": "-5 5",
      "output": "0",
      "type": "basic"
    },
    {
      "input": "100 200",
      "output": "300",
      "type": "basic"
    }
  ],
  "referenceCode": "a, b = map(int, input().split())\nprint(a + b)",
  "tags": ["數學運算", "基礎輸入輸出"]
}
```

### 範例二:檔案 I/O 題目

```json
{
  "title": "Log 檔案分析",
  "description": "請撰寫程式讀取 server.log 檔案,統計檔案中包含 ERROR 和 INFO 的行數。\n\n## 輸入格式\n從 server.log 檔案讀取日誌內容\n\n## 輸出格式\nERROR count: X\nINFO count: Y",
  "difficulty": "medium",
  "samples": [
    {
      "input": "",
      "output": "ERROR count: 0\nINFO count: 0",
      "explanation": "空檔案測試",
      "fileAssets": {
        "server.log": ""
      }
    },
    {
      "input": "",
      "output": "ERROR count: 1\nINFO count: 1",
      "explanation": "基本混合日誌",
      "fileAssets": {
        "server.log": "[INFO] System started\n[ERROR] Connection failed"
      }
    }
  ],
  "testCases": [
    {
      "input": "",
      "output": "ERROR count: 0\nINFO count: 0",
      "type": "edge",
      "description": "空檔案",
      "fileAssets": {
        "server.log": ""
      }
    },
    {
      "input": "",
      "output": "ERROR count: 3\nINFO count: 2",
      "type": "basic",
      "description": "多筆日誌",
      "fileAssets": {
        "server.log": "[INFO] Started\n[ERROR] Failed\nRandom log\n[ERROR] Retry\n[INFO] Success\n[ERROR] Warning"
      }
    },
    {
      "input": "",
      "output": "ERROR count: 5\nINFO count: 5",
      "type": "boundary",
      "description": "大量日誌測試",
      "fileAssets": {
        "server.log": "[ERROR] E1\n[INFO] I1\n[ERROR] E2\n[INFO] I2\n[ERROR] E3\n[INFO] I3\n[ERROR] E4\n[INFO] I4\n[ERROR] E5\n[INFO] I5"
      }
    }
  ],
  "referenceCode": "error_count = 0\ninfo_count = 0\nwith open('server.log', 'r') as f:\n    for line in f:\n        if 'ERROR' in line:\n            error_count += 1\n        if 'INFO' in line:\n            info_count += 1\nprint(f\"ERROR count: {error_count}\")\nprint(f\"INFO count: {info_count}\")",
  "fileAssets": {},
  "tags": ["檔案讀寫", "字串處理", "迴圈"],
  "constraints": "檔案大小不超過 1MB"
}
```

---

## 最佳實踐

### 1. 測試案例設計

- **Samples (1-5個)**:
  - 選擇最具代表性的範例
  - 由簡到繁,幫助使用者理解題意
  - 包含基本情況和一個特殊情況

- **TestCases (10-20個)**:
  - **基本測試** (Basic): 一般情況測試
  - **邊界測試** (Edge): 空輸入、單一元素、最大/最小值
  - **特殊測試** (Boundary): 極限情況、特殊字元

### 2. 檔案資源使用

- 如果所有測試案例使用相同檔案,使用全域 `fileAssets`
- 如果每個測試案例需要不同內容,在 testCase 層級定義 `fileAssets`
- **不要混用** `fileAssets` 和 legacy `input: "filename: content"` 格式

### 3. 程式碼品質

- `referenceCode` 必須:
  - 通過所有 testCases
  - 使用清晰的變數命名
  - 包含必要的註解
  - 遵循 Python 編碼規範 (PEP 8)

### 4. 描述撰寫

- 使用 Markdown 格式化 `description`
- 明確說明輸入輸出格式
- 提供清晰的範例
- 說明特殊限制或注意事項

### 5. 驗證清單

在匯入前檢查:

- [ ] 所有必填欄位都已填寫
- [ ] `samples` 至少有 1 個
- [ ] `testCases` 至少有 10 個
- [ ] `referenceCode` 能通過所有 testCases
- [ ] 如果使用檔案,`fileAssets` 正確定義
- [ ] JSON 格式正確 (可使用 JSONLint 驗證)

---

## TypeScript 型別定義

完整的 TypeScript 介面定義請參考:
[`backend/src/types/question-import.types.ts`](../backend/src/types/question-import.types.ts)

---

## 常見問題

### Q: 為什麼我的檔案題目執行失敗?

**A:** 檢查以下幾點:

1. 確認 `fileAssets` 正確定義在 testCase 層級
2. 確認 `input` 欄位為空字串 (不要包含 `"filename: content"`)
3. 確認 `referenceCode` 使用 `open(filename)` 而非從 stdin 讀取

### Q: 可以同時匯入多個題目嗎?

**A:** 可以! 使用 ZIP 檔案包含多個 JSON,或在單一 JSON 中使用陣列:

```json
{
  "questions": [
    { "title": "Q1", ... },
    { "title": "Q2", ... }
  ]
}
```

### Q: 如何更新已存在的題目?

**A:** 使用相同的 `title` 重新匯入即可覆蓋。系統會根據 `title` 和 `subjectId` 判斷是否為同一題目。

---

## 相關文檔

- [API 文檔](./API.md) (待建立)
- [TypeScript 型別定義](../backend/src/types/question-import.types.ts)
- [專案 README](../README.md)

---

最後更新: 2026-01-27
版本: 2.0
