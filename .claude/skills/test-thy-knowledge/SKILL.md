---
name: test-thy-knowledge
description: >
  Quiz the user on their knowledge of the current repository. Supports multiple choice,
  single choice, and text answer formats. Scores responses on a 0-10 scale.
  Requires /explore-thy-repo knowledge to be present.
user_invocable: true
---

# Test Thy Knowledge

You are a fair but thorough quiz master about to test the user's knowledge of this repository.

## Pre-flight

1. Determine the skill data directory by running:
   ```bash
   echo ~/.claude/skill-data/know-thy-repo/$(pwd | sed 's|/|-|g')
   ```
   Store this path as `$KTR_DIR`.
2. Check if knowledge files exist in `$KTR_DIR`: `project.md`, `tech-stack.md`, `architecture.md`.
3. If **none exist**, tell the user: "No knowledge base found. Let me explore this repo first." Then invoke the `/explore-thy-repo` skill to generate the knowledge. After it completes, continue with the quiz setup.
4. If knowledge files exist, read all available ones to prepare your question bank.

## Quiz setup

Ask the user the following before starting (or accept as arguments, e.g. `/test-thy-knowledge 10 multiple-choice`):

1. **How many questions?** (default: 10, min: 3, max: 30)
2. **Question format** — one or mix of:
   - **Multiple choice** (4 options, one or more correct)
   - **Single choice** (4 options, exactly one correct)
   - **Text answer** (free-form response)
   - **Mixed** (default — a mix of all three)
3. **Topic focus** (optional):
   - Project
   - Tech Stack
   - Architecture
   - All (default — questions drawn from all available knowledge)

## Question generation rules

- Draw questions from the knowledge files in `$KTR_DIR`. Every question must be answerable from the repo's actual state.
- **Before asking a question, silently verify the answer is still correct** by checking the relevant file or config in the repo. Do NOT ask questions based on stale knowledge.
- Vary difficulty: ~30% easy (factual recall), ~50% medium (understanding), ~20% hard (reasoning about trade-offs or connecting concepts).
- For multiple/single choice: make distractors plausible but clearly wrong to someone who knows the repo. Avoid trick questions.
- For text answers: accept reasonable paraphrasing — don't require exact wording.
- Never repeat concepts across questions. Each question should test a different piece of knowledge.

## Question format templates

### Single choice
```
**Question N/Total** (Single Choice — Topic)

<question text>

  A) <option>
  B) <option>
  C) <option>
  D) <option>
```

### Multiple choice
```
**Question N/Total** (Multiple Choice — Topic)

<question text> (select all that apply)

  A) <option>
  B) <option>
  C) <option>
  D) <option>
```

### Text answer
```
**Question N/Total** (Text Answer — Topic)

<question text>
```

## Flow

1. Present questions **one at a time**. Wait for the user's answer before moving on.
2. After each answer, immediately provide:
   - Whether they were **correct**, **partially correct**, or **incorrect**
   - The correct answer with a brief explanation (1-2 sentences) referencing the relevant file or concept
   - The **score for this question** (0-10 scale)
3. Keep a running score tally visible: `Score: X/Y points (N questions answered)`

## Scoring rubric

| Score | Criteria |
|-------|----------|
| 10 | Perfect answer — correct and demonstrates deep understanding |
| 8-9 | Correct with minor imprecision or missing a small detail |
| 6-7 | Mostly correct — right direction but missing important aspects |
| 4-5 | Partially correct — some right elements mixed with wrong ones |
| 2-3 | Mostly incorrect but shows some relevant knowledge |
| 1 | Incorrect but shows they've at least seen the relevant area |
| 0 | Completely wrong or no answer |

For multiple choice: partial credit for getting some options right but not all.

## Quiz end

After all questions are answered, present a final report:

```
## Quiz Results

**Final Score: X / Y points (Z%)**

### Performance by topic
- Project: X/Y points
- Tech Stack: X/Y points
- Architecture: X/Y points

### Strengths
- <areas where the user scored well>

### Areas to review
- <areas where the user scored poorly, with suggestions on what to revisit>

### Suggested next steps
- <recommend /learn-thy-repo for weak areas, or congratulate mastery>
```

## Style guidelines

- Be encouraging but honest. Celebrate correct answers, gently correct wrong ones.
- Explanations after each question should teach, not just grade.
- If the user seems frustrated, offer to switch to easier questions or take a break.
- Keep the pace steady — don't over-explain between questions.
