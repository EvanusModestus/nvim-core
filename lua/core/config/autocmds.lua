-- ==============================================================================
-- Auto Commands
-- ==============================================================================
-- Automatic behaviors and file-type specific configurations
-- ==============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ==============================================================================
-- General Auto Commands
-- ==============================================================================

local general = augroup("General", { clear = true })

-- Auto-save when losing focus (SSH disconnection protection)
autocmd({ "FocusLost", "BufLeave" }, {
    group = general,
    pattern = "*",
    callback = function()
        -- Only save if buffer is modified, has a name, and is writable
        if vim.bo.modified and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
    desc = "Auto-save on focus lost or buffer leave"
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    group = general,
    pattern = "*",
    command = [[%s/\s\+$//e]],
    desc = "Remove trailing whitespace on save"
})

-- Highlight yanked text
autocmd("TextYankPost", {
    group = general,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
    desc = "Highlight yanked text"
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
    group = general,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Return to last edit position"
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
    group = general,
    pattern = "*",
    command = "tabdo wincmd =",
    desc = "Resize splits on window resize"
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
    group = general,
    pattern = { "qf", "help", "man", "lspinfo", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close with 'q' in certain filetypes"
})

-- ==============================================================================
-- File Type Specific Settings
-- ==============================================================================

local filetype_settings = augroup("FileTypeSettings", { clear = true })

-- Markdown
autocmd("FileType", {
    group = filetype_settings,
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.conceallevel = 2

        -- Note-taking abbreviations
        local abbrev = vim.cmd

        -- Todo/Checkbox items
        abbrev([[iabbrev <buffer> todo - [ ] ]])
        abbrev([[iabbrev <buffer> done - [x] ]])
        abbrev([[iabbrev <buffer> pending - [~] ]])
        abbrev([[iabbrev <buffer> cancelled - [-] ]])

        -- Lists
        abbrev([[iabbrev <buffer> ul - ]])
        abbrev([[iabbrev <buffer> ol 1. ]])
        abbrev([[iabbrev <buffer> task - [ ] ]])

        -- Headers (quick access)
        abbrev([[iabbrev <buffer> h1 # ]])
        abbrev([[iabbrev <buffer> h2 ## ]])
        abbrev([[iabbrev <buffer> h3 ### ]])
        abbrev([[iabbrev <buffer> h4 #### ]])
        abbrev([[iabbrev <buffer> h5 ##### ]])
        abbrev([[iabbrev <buffer> h6 ###### ]])

        -- Code blocks - Programming Languages
        abbrev([[iabbrev <buffer> pycode ```python<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> jscode ```javascript<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> tscode ```typescript<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> shcode ```bash<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> luacode ```lua<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> rustcode ```rust<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> gocode ```go<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> ccode ```c<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> cppcode ```cpp<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> javacode ```java<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> csharpcode ```csharp<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> phpcode ```php<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> rubycode ```ruby<CR>```<Esc>O]])

        -- Code blocks - Data/Config Languages
        abbrev([[iabbrev <buffer> sqlcode ```sql<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> jsoncode ```json<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> yamlcode ```yaml<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> xmlcode ```xml<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> tomlcode ```toml<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> csvcode ```csv<CR>```<Esc>O]])

        -- Code blocks - Web Languages
        abbrev([[iabbrev <buffer> htmlcode ```html<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> csscode ```css<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> scsscode ```scss<CR>```<Esc>O]])

        -- Code blocks - Shell/Terminal
        abbrev([[iabbrev <buffer> shellcode ```shell<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> console ```console<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> powershell ```powershell<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> cmdcode ```cmd<CR>```<Esc>O]])

        -- Code blocks - Other
        abbrev([[iabbrev <buffer> mdcode ```markdown<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> diffcode ```diff<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> gitcode ```git<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> dockercode ```dockerfile<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> makecode ```makefile<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> vimcode ```vim<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> regexcode ```regex<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> textcode ```text<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> plaincode ```plaintext<CR>```<Esc>O]])
        abbrev([[iabbrev <buffer> code ```<CR>```<Esc>O]])

        -- Links and references
        abbrev([[iabbrev <buffer> link [](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
        abbrev([[iabbrev <buffer> img ![](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
        abbrev([[iabbrev <buffer> ref [][]<Left><Left><Left>]])

        -- Note-taking templates and callouts
        abbrev([[iabbrev <buffer> note > **Note:** ]])
        abbrev([[iabbrev <buffer> warn > **Warning:** ]])
        abbrev([[iabbrev <buffer> warning > **Warning:** ]])
        abbrev([[iabbrev <buffer> tip > **Tip:** ]])
        abbrev([[iabbrev <buffer> important > **Important:** ]])
        abbrev([[iabbrev <buffer> info > **Info:** ]])
        abbrev([[iabbrev <buffer> danger > **Danger:** ]])
        abbrev([[iabbrev <buffer> error > **Error:** ]])
        abbrev([[iabbrev <buffer> success > **Success:** ]])
        abbrev([[iabbrev <buffer> question > **Question:** ]])
        abbrev([[iabbrev <buffer> quote > ]])

        -- Date/time stamps
        abbrev([[iabbrev <buffer> date <C-R>=strftime("%Y-%m-%d")<CR>]])
        abbrev([[iabbrev <buffer> time <C-R>=strftime("%H:%M")<CR>]])
        abbrev([[iabbrev <buffer> datetime <C-R>=strftime("%Y-%m-%d %H:%M")<CR>]])
        abbrev([[iabbrev <buffer> timestamp <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>]])

        -- Common formatting
        abbrev([[iabbrev <buffer> bold ****<Left><Left>]])
        abbrev([[iabbrev <buffer> italic **<Left>]])
        abbrev([[iabbrev <buffer> strike ~~~~<Left><Left>]])
        abbrev([[iabbrev <buffer> inline `<BS>]])

        -- Table template (simplified to avoid pipe escaping issues)
        abbrev([[iabbrev <buffer> table <Bar> Header 1 <Bar> Header 2 <Bar>]])

        -- Horizontal rule
        abbrev([[iabbrev <buffer> hr ---]])

        -- Technical writing helpers
        abbrev([[iabbrev <buffer> TODO <!-- TODO: -->]])
        abbrev([[iabbrev <buffer> FIXME <!-- FIXME: -->]])
        abbrev([[iabbrev <buffer> NOTE <!-- NOTE: -->]])
        abbrev([[iabbrev <buffer> HACK <!-- HACK: -->]])
        abbrev([[iabbrev <buffer> XXX <!-- XXX: -->]])
        abbrev([[iabbrev <buffer> BUG <!-- BUG: -->]])
        abbrev([[iabbrev <buffer> DEPRECATED <!-- DEPRECATED: -->]])

        -- Details/Summary (collapsible sections)
        abbrev([[iabbrev <buffer> details <details><CR><summary></summary><CR><CR></details><Esc>2kA]])

        -- Frontmatter template
        abbrev([[iabbrev <buffer> frontmatter ---<CR>title: <CR>date: <C-R>=strftime("%Y-%m-%d")<CR><CR>author: <CR>tags: []<CR>---<Esc>4kA]])

        -- Code documentation template (simplified)
        abbrev([[iabbrev <buffer> apidoc ## API Documentation<CR><CR>### Endpoint<CR>```<CR>METHOD /path<CR>```<CR><CR>### Parameters<CR>- `name` (type, required): Description<CR><CR>### Response<CR>```json<CR>{<CR>}<CR>```<CR><CR>### Example<CR>```bash<CR>curl -X METHOD https://api.example.com/path<CR>```]])

        -- Keyboard shortcuts documentation
        abbrev([[iabbrev <buffer> kbd <kbd></kbd><Left><Left><Left><Left><Left><Left>]])

        -- Footnote
        abbrev([[iabbrev <buffer> footnote [^1]<CR><CR>[^1]: ]])

        -- Task list item with priority
        abbrev([[iabbrev <buffer> priority - [ ] **[P1]** ]])

        -- Code output/result block
        abbrev([[iabbrev <buffer> output **Output:**<CR>```<CR>```<Esc>O]])

        -- Example block
        abbrev([[iabbrev <buffer> example **Example:**<CR>```<CR>```<Esc>O]])

        -- Badge/Shield
        abbrev([[iabbrev <buffer> badge ![](https://img.shields.io/)]])

        -- Table of contents placeholder
        abbrev([[iabbrev <buffer> toc ## Table of Contents<CR><CR>- []()<CR>- []()<CR>- []()]])

        -- Meeting notes template
        abbrev([[iabbrev <buffer> meeting # Meeting Notes<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Attendees:** <CR><CR>## Agenda<CR>- [ ] <CR><CR>## Discussion<CR><CR>## Action Items<CR>- [ ] ]])

        -- Daily notes template
        abbrev([[iabbrev <buffer> daily # Daily Notes - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>## Tasks<CR>- [ ] <CR><CR>## Notes<CR><CR>## Tomorrow<CR>- [ ] ]])

        -- Project notes template
        abbrev([[iabbrev <buffer> project # Project: <CR><CR>## Overview<CR><CR>## Goals<CR>- [ ] <CR><CR>## Timeline<CR><CR>## Resources<CR>]])

        -- ==================================================================
        -- WORKFLOW TEMPLATES - For Daily Life & Professional Use
        -- ==================================================================

        -- Weekly Review Template
        abbrev([[iabbrev <buffer> weekly # Weekly Review - Week <C-R>=strftime("%U, %Y")<CR><CR><CR>## Accomplishments<CR>- <CR><CR>## Challenges<CR>- <CR><CR>## Next Week Goals<CR>- [ ] <CR><CR>## Notes<CR>]])

        -- Weekly Planning Template
        abbrev([[iabbrev <buffer> weekplan # Weekly Plan - <C-R>=strftime("%Y-W%U")<CR><CR><CR>## This Week's Goals<CR>- [ ] <CR><CR>## Monday<CR>- [ ] <CR><CR>## Tuesday<CR>- [ ] <CR><CR>## Wednesday<CR>- [ ] <CR><CR>## Thursday<CR>- [ ] <CR><CR>## Friday<CR>- [ ] <CR><CR>## Weekend<CR>- [ ] ]])

        -- Sprint Planning (Agile)
        abbrev([[iabbrev <buffer> sprint # Sprint Planning - Sprint <CR><CR>**Duration:** <C-R>=strftime("%Y-%m-%d")<CR> to <CR>**Team:** <CR><CR>## Sprint Goal<CR><CR>## User Stories<CR>- [ ] **[Story]** As a ___ I want ___ so that ___<CR>  - **Acceptance Criteria:**<CR>  - **Estimate:** <CR><CR>## Tasks<CR>- [ ] <CR><CR>## Risks<CR>- ]])

        -- Retrospective Template
        abbrev([[iabbrev <buffer> retro # Retrospective - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>## What Went Well 🎉<CR>- <CR><CR>## What Could Be Improved 🔧<CR>- <CR><CR>## Action Items<CR>- [ ] <CR><CR>## Appreciations 💙<CR>- ]])

        -- ==================================================================
        -- TECHNICAL WRITER TEMPLATES
        -- ==================================================================

        -- Tutorial Template
        abbrev([[iabbrev <buffer> tutorial # Tutorial: <CR><CR>## Overview<CR>**Time:** ~X minutes<CR>**Level:** Beginner/Intermediate/Advanced<CR><CR>## Prerequisites<CR>- <CR><CR>## What You'll Learn<CR>- <CR><CR>## Steps<CR><CR>### Step 1: <CR><CR>### Step 2: <CR><CR>## Troubleshooting<CR><CR>## Next Steps<CR>]])

        -- How-To Guide Template
        abbrev([[iabbrev <buffer> howto # How to: <CR><CR>## Problem<CR><CR>## Solution<CR><CR>## Steps<CR><CR>1. <CR>2. <CR>3. <CR><CR>## Expected Result<CR><CR>## Common Issues<CR>]])

        -- Documentation Page Template
        abbrev([[iabbrev <buffer> docpage # Documentation: <CR><CR>## Description<CR><CR>## Usage<CR><CR>```<CR>```<CR><CR>## Parameters<CR>- `param1` (type, required): Description<CR><CR>## Examples<CR><CR>### Basic Example<CR>```<CR>```<CR><CR>### Advanced Example<CR>```<CR>```<CR><CR>## Notes<CR>]])

        -- Changelog Entry
        abbrev([[iabbrev <buffer> changelog ## [Version] - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>### Added<CR>- <CR><CR>### Changed<CR>- <CR><CR>### Fixed<CR>- <CR><CR>### Removed<CR>- ]])

        -- Release Notes Template
        abbrev([[iabbrev <buffer> release # Release Notes - v<CR><CR>**Release Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Highlights<CR>- <CR><CR>## New Features<CR>- <CR><CR>## Improvements<CR>- <CR><CR>## Bug Fixes<CR>- <CR><CR>## Breaking Changes<CR>- <CR><CR>## Upgrade Guide<CR>]])

        -- ==================================================================
        -- ENGINEER TEMPLATES
        -- ==================================================================

        -- Bug Report Template
        abbrev([[iabbrev <buffer> bugreport # Bug Report<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Severity:** Critical/High/Medium/Low<CR><CR>## Description<CR><CR>## Steps to Reproduce<CR>1. <CR>2. <CR>3. <CR><CR>## Expected Behavior<CR><CR>## Actual Behavior<CR><CR>## Environment<CR>- OS: <CR>- Version: <CR>- Browser: <CR><CR>## Logs/Screenshots<CR>```<CR>```<CR><CR>## Possible Solution<CR>]])

        -- Feature Request Template
        abbrev([[iabbrev <buffer> feature # Feature Request<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Priority:** High/Medium/Low<CR><CR>## Problem Statement<CR>As a ___ I need ___ so that ___<CR><CR>## Proposed Solution<CR><CR>## Alternatives Considered<CR>- <CR><CR>## Acceptance Criteria<CR>- [ ] <CR><CR>## Technical Considerations<CR>- <CR><CR>## Effort Estimate<CR>]])

        -- Architecture Decision Record (ADR)
        abbrev([[iabbrev <buffer> adr # ADR: <CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Status:** Proposed/Accepted/Deprecated/Superseded<CR><CR>## Context<CR>What is the issue we're facing?<CR><CR>## Decision<CR>What are we doing about it?<CR><CR>## Consequences<CR>What becomes easier or harder?<CR><CR>### Positive<CR>- <CR><CR>### Negative<CR>- <CR><CR>### Risks<CR>- ]])

        -- Code Review Template
        abbrev([[iabbrev <buffer> codereview # Code Review - <C-R>=strftime("%Y-%m-%d")<CR><CR>**Reviewer:** <CR>**PR/Branch:** <CR><CR>## Summary<CR><CR>## ✅ Strengths<CR>- <CR><CR>## 🔧 Issues Found<CR>- [ ] <CR><CR>## 💡 Suggestions<CR>- <CR><CR>## 🧪 Testing Notes<CR>- [ ] Unit tests pass<CR>- [ ] Manual testing completed<CR>- [ ] Edge cases considered<CR><CR>## Decision<CR>- [ ] Approve<CR>- [ ] Request changes<CR>- [ ] Comment only]])

        -- Technical Design Document
        abbrev([[iabbrev <buffer> design # Technical Design: <CR><CR>**Author:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Overview<CR><CR>## Goals<CR>- <CR><CR>## Non-Goals<CR>- <CR><CR>## Design<CR><CR>### Architecture<CR><CR>### Data Models<CR>```<CR>```<CR><CR>### API Design<CR>```<CR>```<CR><CR>## Alternatives Considered<CR><CR>## Security Considerations<CR><CR>## Performance Considerations<CR><CR>## Testing Strategy<CR><CR>## Rollout Plan<CR>1. <CR><CR>## Monitoring & Metrics<CR>]])

        -- Incident Post-Mortem
        abbrev([[iabbrev <buffer> postmortem # Incident Post-Mortem<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Incident Date:** <CR>**Duration:** <CR>**Severity:** <CR><CR>## Summary<CR><CR>## Timeline<CR>- **HH:MM** - <CR><CR>## Root Cause<CR><CR>## Impact<CR>- Users affected: <CR>- Systems affected: <CR><CR>## Resolution<CR><CR>## Action Items<CR>- [ ] **[P1]** <CR><CR>## Lessons Learned<CR><CR>### What Went Well<CR>- <CR><CR>### What Went Wrong<CR>- <CR><CR>### Where We Got Lucky<CR>- ]])

        -- ==================================================================
        -- STUDENT TEMPLATES
        -- ==================================================================

        -- Class Notes Template
        abbrev([[iabbrev <buffer> classnotes # Class Notes - <C-R>=strftime("%Y-%m-%d")<CR><CR>**Course:** <CR>**Topic:** <CR>**Professor:** <CR><CR>## Key Concepts<CR>- <CR><CR>## Notes<CR><CR>## Examples<CR>```<CR>```<CR><CR>## Questions<CR>- [ ] <CR><CR>## Action Items<CR>- [ ] Read: <CR>- [ ] Practice: <CR>- [ ] Review: ]])

        -- Study Guide Template
        abbrev([[iabbrev <buffer> studyguide # Study Guide: <CR><CR>**Exam Date:** <CR>**Topics Covered:** <CR><CR>## Key Concepts<CR><CR>### Concept 1<CR>**Definition:** <CR>**Example:** <CR>**Why it matters:** <CR><CR>## Formulas & Equations<CR>```<CR>```<CR><CR>## Practice Problems<CR>1. <CR><CR>## Study Checklist<CR>- [ ] Review lecture notes<CR>- [ ] Complete practice problems<CR>- [ ] Review homework<CR>- [ ] Create flashcards<CR>- [ ] Study group session]])

        -- Research Notes Template
        abbrev([[iabbrev <buffer> research # Research Notes<CR><CR>**Topic:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Research Question<CR><CR>## Sources<CR>1. <CR><CR>## Key Findings<CR>- <CR><CR>## Quotes & Citations<CR>> <CR><CR>## My Analysis<CR><CR>## Next Steps<CR>- [ ] ]])

        -- Assignment Template
        abbrev([[iabbrev <buffer> assignment # Assignment: <CR><CR>**Course:** <CR>**Due Date:** <CR>**Points:** <CR><CR>## Requirements<CR>- [ ] <CR><CR>## Approach<CR><CR>## Notes<CR><CR>## Resources<CR>- <CR><CR>## Checklist Before Submission<CR>- [ ] Requirements met<CR>- [ ] Proofread<CR>- [ ] Citations formatted<CR>- [ ] Files named correctly<CR>- [ ] Submitted on time]])

        -- Reading Notes Template
        abbrev([[iabbrev <buffer> readingnotes # Reading Notes<CR><CR>**Title:** <CR>**Author:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Summary<CR><CR>## Key Points<CR>- <CR><CR>## Quotes<CR>> <CR><CR>## My Thoughts<CR><CR>## Questions<CR>- <CR><CR>## Action Items<CR>- [ ] ]])

        -- ==================================================================
        -- EDUCATOR TEMPLATES
        -- ==================================================================

        -- Lesson Plan Template
        abbrev([[iabbrev <buffer> lesson # Lesson Plan<CR><CR>**Course:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Duration:** <CR>**Grade Level:** <CR><CR>## Learning Objectives<CR>Students will be able to:<CR>- <CR><CR>## Materials Needed<CR>- <CR><CR>## Introduction (X min)<CR><CR>## Main Activity (X min)<CR><CR>## Practice/Application (X min)<CR><CR>## Assessment<CR>- <CR><CR>## Homework/Follow-up<CR>- <CR><CR>## Notes/Reflections<CR>]])

        -- Course Syllabus Template
        abbrev([[iabbrev <buffer> syllabus # Course Syllabus<CR><CR>**Course Title:** <CR>**Instructor:** <CR>**Term:** <CR>**Credits:** <CR><CR>## Course Description<CR><CR>## Learning Outcomes<CR>By the end of this course, students will be able to:<CR>1. <CR><CR>## Required Materials<CR>- <CR><CR>## Grading<CR>- Assignments: X%<CR>- Exams: X%<CR>- Participation: X%<CR>- Final Project: X%<CR><CR>## Schedule<CR><Bar> Week <Bar> Topic <Bar> Assignments <Bar><CR><CR>## Policies<CR><CR>### Attendance<CR><CR>### Late Work<CR><CR>### Academic Integrity<CR>]])

        -- Assessment Rubric Template
        abbrev([[iabbrev <buffer> rubric # Grading Rubric<CR><CR>**Assignment:** <CR>**Total Points:** <CR><CR><Bar> Criteria <Bar> Exemplary (A) <Bar> Proficient (B) <Bar> Developing (C) <Bar> Beginning (D/F) <Bar><CR><CR>## Comments<CR>]])

        -- Student Feedback Template
        abbrev([[iabbrev <buffer> feedback # Student Feedback<CR><CR>**Student:** <CR>**Assignment:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Strengths<CR>- <CR><CR>## Areas for Growth<CR>- <CR><CR>## Specific Feedback<CR><CR>## Next Steps<CR>- [ ] <CR><CR>**Grade:** ]])

        -- ==================================================================
        -- PRODUCTIVITY & PERSONAL TEMPLATES
        -- ==================================================================

        -- Ideas/Brainstorm Template
        abbrev([[iabbrev <buffer> brainstorm # Brainstorm: <CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Problem/Goal<CR><CR>## Ideas<CR>- 💡 <CR><CR>## Best Ideas<CR>1. <CR><CR>## Next Actions<CR>- [ ] ]])

        -- Problem Solving Template
        abbrev([[iabbrev <buffer> problem # Problem Solving<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## The Problem<CR><CR>## Why This Matters<CR><CR>## Possible Solutions<CR>1. <CR>   - Pros: <CR>   - Cons: <CR><CR>## Chosen Solution<CR><CR>## Action Plan<CR>- [ ] <CR><CR>## Results<CR>]])

        -- Decision Log Template
        abbrev([[iabbrev <buffer> decision # Decision Log<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Decision:** <CR><CR>## Context<CR><CR>## Options Considered<CR>1. <CR><CR>## Decision Made<CR><CR>## Reasoning<CR><CR>## Expected Outcome<CR><CR>## Review Date<CR>]])

        -- Book Summary Template
        abbrev([[iabbrev <buffer> booksummary # Book Summary<CR><CR>**Title:** <CR>**Author:** <CR>**Finished:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Rating:** ⭐⭐⭐⭐⭐<CR><CR>## Summary<CR><CR>## Key Takeaways<CR>1. <CR><CR>## Favorite Quotes<CR>> <CR><CR>## How I'll Apply This<CR>- [ ] <CR><CR>## Related Books<CR>- ]])

        -- Goal Setting Template
        abbrev([[iabbrev <buffer> goals # Goals - <C-R>=strftime("%Y")<CR><CR><CR>## Long-term Vision (5 years)<CR><CR>## This Year's Goals<CR><CR>### Career<CR>- [ ] <CR><CR>### Learning<CR>- [ ] <CR><CR>### Health<CR>- [ ] <CR><CR>### Personal<CR>- [ ] <CR><CR>## Quarterly Milestones<CR><CR>### Q1<CR>- [ ] <CR><CR>### Q2<CR>- [ ] <CR><CR>### Q3<CR>- [ ] <CR><CR>### Q4<CR>- [ ] ]])

        -- Auto-continuation for lists and checkboxes (like Microsoft Word)
        -- When you press Enter after a bullet/checkbox, it creates another one
        vim.keymap.set("i", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            -- Check for checkbox patterns: - [ ], - [x], - [~], - [-]
            local checkbox_pattern = "^(%s*)%- %[.%] (.*)$"
            local checkbox_empty = "^(%s*)%- %[.%]%s*$"
            local indent, content = line:match(checkbox_pattern)

            if indent and content then
                -- Line has content, create new checkbox
                local checkbox_type = line:match("^%s*%- %[(.-)%]")
                -- Always create unchecked checkbox for continuation
                return "<CR>" .. indent .. "- [ ] "
            elseif line:match(checkbox_empty) then
                -- Empty checkbox line, remove it and do normal Enter
                -- Use key sequence: Esc, delete line (dd), open line above (O)
                return "<Esc>ddO"
            end

            -- Check for bullet list: -
            local bullet_pattern = "^(%s*)%- (.+)$"
            local bullet_empty = "^(%s*)%- %s*$"
            indent, content = line:match(bullet_pattern)

            if indent and content then
                -- Line has content, create new bullet
                return "<CR>" .. indent .. "- "
            elseif line:match(bullet_empty) then
                -- Empty bullet line, remove it and do normal Enter
                -- Use key sequence: Esc, delete line (dd), open line above (O)
                return "<Esc>ddO"
            end

            -- Check for numbered list: 1., 2., etc.
            local number_pattern = "^(%s*)(%d+)%. (.+)$"
            local number_empty = "^(%s*)(%d+)%. %s*$"
            local num
            indent, num, content = line:match(number_pattern)

            if indent and num and content then
                -- Line has content, create new numbered item
                local next_num = tonumber(num) + 1
                return "<CR>" .. indent .. next_num .. ". "
            elseif line:match(number_empty) then
                -- Empty numbered line, remove it and do normal Enter
                -- Use key sequence: Esc, delete line (dd), open line above (O)
                return "<Esc>ddO"
            end

            -- Default: just press Enter normally
            return "<CR>"
        end, { buffer = true, expr = true, desc = "Auto-continue lists and checkboxes" })

        -- Tab: Indent list item (add 2 spaces)
        vim.keymap.set("i", "<Tab>", function()
            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            -- Check if line is a list item (checkbox, bullet, or numbered)
            if line:match("^%s*%- %[.%]") or line:match("^%s*%- ") or line:match("^%s*%d+%. ") then
                -- Add 2 spaces at the beginning
                vim.api.nvim_set_current_line("  " .. line)
                -- Move cursor forward by 2
                vim.api.nvim_win_set_cursor(0, {row, col + 2})
            else
                -- Default: insert tab character
                vim.api.nvim_put({"\t"}, "c", false, true)
            end
        end, { buffer = true, desc = "Indent list items" })

        -- Shift-Tab: Dedent list item (remove 2 spaces)
        vim.keymap.set("i", "<S-Tab>", function()
            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            -- Check if line is a list item with indentation
            if (line:match("^%s+%- %[.%]") or line:match("^%s+%- ") or line:match("^%s+%d+%. ")) and line:match("^  ") then
                -- Remove 2 spaces from the beginning
                vim.api.nvim_set_current_line(line:sub(3))
                -- Move cursor back by 2
                vim.api.nvim_win_set_cursor(0, {row, math.max(0, col - 2)})
            end
            -- If not a list item, do nothing
        end, { buffer = true, desc = "Dedent list items" })
    end,
    desc = "Markdown settings and abbreviations"
})

-- Git commit messages
autocmd("FileType", {
    group = filetype_settings,
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 72
    end,
    desc = "Git commit settings"
})

-- YAML
autocmd("FileType", {
    group = filetype_settings,
    pattern = { "yaml", "yml" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
    desc = "YAML 2-space indentation"
})

-- Python
autocmd("FileType", {
    group = filetype_settings,
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.textwidth = 88  -- Black formatter default
    end,
    desc = "Python settings"
})

-- Lua
autocmd("FileType", {
    group = filetype_settings,
    pattern = "lua",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
    desc = "Lua settings"
})

-- JSON
autocmd("FileType", {
    group = filetype_settings,
    pattern = "json",
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
    desc = "JSON 2-space indentation"
})

-- ==============================================================================
-- Performance Optimizations
-- ==============================================================================

local performance = augroup("Performance", { clear = true })

-- Disable certain features for large files
autocmd("BufReadPre", {
    group = performance,
    pattern = "*",
    callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%"))
        if file_size > 1024 * 1024 then  -- 1MB
            vim.opt_local.spell = false
            vim.opt_local.swapfile = false
            vim.opt_local.undofile = false
            vim.opt_local.syntax = "off"
        end
    end,
    desc = "Optimize for large files"
})

-- ==============================================================================
-- Terminal Settings
-- ==============================================================================

local terminal = augroup("Terminal", { clear = true })

-- Start terminal in insert mode
autocmd("TermOpen", {
    group = terminal,
    pattern = "*",
    command = "startinsert",
    desc = "Start terminal in insert mode"
})

-- Disable line numbers in terminal
autocmd("TermOpen", {
    group = terminal,
    pattern = "*",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
    desc = "Disable UI elements in terminal"
})

-- ==============================================================================
-- Netrw Settings
-- ==============================================================================

local netrw = augroup("Netrw", { clear = true })

-- Enable line numbers in netrw for easier navigation
autocmd("FileType", {
    group = netrw,
    pattern = "netrw",
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end,
    desc = "Enable line numbers in netrw"
})

-- ==============================================================================
-- Quickfix Improvements
-- ==============================================================================

local quickfix = augroup("Quickfix", { clear = true })

-- Automatically open quickfix after grep
autocmd("QuickFixCmdPost", {
    group = quickfix,
    pattern = "[^l]*",
    command = "cwindow",
    desc = "Open quickfix after grep"
})

-- Automatically open location list
autocmd("QuickFixCmdPost", {
    group = quickfix,
    pattern = "l*",
    command = "lwindow",
    desc = "Open location list"
})
