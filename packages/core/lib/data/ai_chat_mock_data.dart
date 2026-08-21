enum MessageRole { user, ai }

class AiChatMessage {
  final String content;
  final DateTime timestamp;
  final MessageRole role;

  const AiChatMessage({
    required this.content,
    required this.timestamp,
    required this.role,
  });
}

class AiChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<AiChatMessage> messages;

  const AiChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.modifiedAt,
    required this.messages,
  });
}

final List<AiChatSession> mockChatSessions = [
  AiChatSession(
    id: '1',
    title: 'Quantum Computing Intro',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    modifiedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    messages: [
      AiChatMessage(
        content: 'Explain quantum computing in simple terms.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
        role: MessageRole.user,
      ),
      AiChatMessage(
        content: '''## What is Quantum Computing?

Quantum computing is a fundamentally different way of processing information — one that harnesses the strange laws of **quantum mechanics**.

### Classical vs Quantum

| Feature | Classical Computer | Quantum Computer |
|---|---|---|
| Basic unit | Bit (0 or 1) | Qubit (0, 1, or both) |
| Processing | Sequential / parallel | Massively parallel |
| Best for | General tasks | Optimization, simulation |

### Key Concepts

- **Superposition** — A qubit can be 0 and 1 *at the same time*, until observed.
- **Entanglement** — Two qubits can be linked so that the state of one instantly affects the other, regardless of distance.
- **Interference** — Quantum algorithms amplify correct answers and cancel wrong ones.

> Think of it like this: a classical computer tries every door one by one. A quantum computer tries *all doors simultaneously*.''',
        timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
        role: MessageRole.ai,
      ),
      AiChatMessage(
        content: 'Give me an example of its real-world application.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        role: MessageRole.user,
      ),
      AiChatMessage(
        content: '''## Real-World Applications of Quantum Computing

Here are some of the most promising areas where quantum computing is already making an impact:

### 1. 🧬 Drug Discovery
Quantum computers can simulate molecular interactions at the atomic level — something classical computers struggle with exponentially. Companies like **IBM** and **Google** are partnering with pharma to model protein folding and drug binding.

### 2. 🔐 Cryptography
Quantum algorithms like **Shor's algorithm** can theoretically break RSA encryption, which is driving the field of *post-quantum cryptography* to build quantum-safe protocols.

### 3. 📦 Supply Chain Optimization
Quantum annealing (used by **D-Wave**) solves complex optimization problems — like minimizing shipping routes across thousands of variables — far faster than classical solvers.

### 4. 🌦️ Climate Modelling
Simulating atmospheric chemistry at quantum scale enables more accurate climate predictions and helps design better **carbon capture** materials.

---

**Bottom line:** Quantum computing won't replace classical computing — it will *complement* it for specific hard problems.''',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        role: MessageRole.ai,
      ),
    ],
  ),
  AiChatSession(
    id: '2',
    title: 'Flutter Monorepo',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
    messages: [
      AiChatMessage(
        content: 'What is Flutter monorepo?',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        role: MessageRole.user,
      ),
      AiChatMessage(
        content: '''## Flutter Monorepo Architecture

A **Flutter monorepo** is a single Git repository that contains multiple related packages and applications — all managed together.

### Why Use a Monorepo?

- ✅ **Shared code** — Design systems, utilities, and domain logic live in one place
- ✅ **Atomic commits** — A single PR can update multiple packages consistently
- ✅ **Simplified dependency management** — No version mismatch between internal packages
- ✅ **Easier refactoring** — Rename a widget across 5 packages in one go

### Typical Structure

```
my_app/
├── app/                  # Consumer shell (thin)
├── packages/
│   ├── core/             # Design system, primitives
│   ├── courses/          # Courses domain
│   └── exams/            # Exams domain
└── melos.yaml            # Monorepo tooling config
```

### Tooling

The most common tool is **Melos**, which provides:
- `melos run build` — run scripts across packages
- `melos bootstrap` — link local packages together
- `melos publish` — publish packages to pub.dev

> 🔑 The key principle: **packages are feature domains, not layers**. Each package owns its data, logic, and UI for one vertical slice.''',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        role: MessageRole.ai,
      ),
    ],
  ),
  AiChatSession(
    id: '3',
    title: 'Cosine Similarity vs Dot Product',
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
    modifiedAt: DateTime.now().subtract(const Duration(days: 14)),
    messages: [
      AiChatMessage(
        content: 'Comparison between cosine similarity and dot product',
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        role: MessageRole.user,
      ),
      AiChatMessage(
        content: '''## Cosine Similarity vs Dot Product

Both are ways to measure the **relationship between two vectors**, but they capture different things.

### Definitions

**Dot Product**
```
A · B = |A| × |B| × cos(θ)
```
It measures both the *direction* and the *magnitude* of two vectors.

**Cosine Similarity**
```
cos(θ) = (A · B) / (|A| × |B|)
```
It normalizes the dot product, so only *direction* matters — not magnitude.

---

### Comparison Table

| Property | Dot Product | Cosine Similarity |
|---|---|---|
| Range | −∞ to +∞ | −1 to +1 |
| Sensitive to magnitude? | ✅ Yes | ❌ No |
| Normalized vectors | Equivalent | Equivalent |
| Use case | Raw similarity score | Semantic / text similarity |

### When to Use Which?

- Use **dot product** when vector magnitude carries meaning (e.g. recommendation scores, attention weights in transformers).
- Use **cosine similarity** when you only care about *direction* — e.g. comparing document embeddings regardless of length.

> 💡 **In practice**: if your embeddings are already L2-normalized (unit vectors), the dot product *equals* cosine similarity. This is why vector databases like Pinecone and Weaviate often use dot product internally for speed.''',
        timestamp: DateTime.now().subtract(const Duration(days: 14)),
        role: MessageRole.ai,
      ),
    ],
  ),
];
