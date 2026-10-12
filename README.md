# geo-checker-ts

The TypeScript geometric proof checker from [Ender](https://github.com/hsharriman/ender),
packaged to run from the command line or as a Docker HTTP service. No UI.

- `src/checker/` — lexer/parser, statement + reason definitions, checker
  (see `src/checker/README.md`, `ERROR_CODES.md`, `glossary.md`)
- `src/geometry-object/` — geometry model used by the checker
- `scripts/scanProofsCli.ts` — batch-check a directory of proofs

## Command line

Requires Node 18+.

```bash
npm install
npm run --silent checkProof -- path/to/proof.txt    # JSON result; exit 1 if incorrect
npm run --silent scanProofs -- path/to/proofs/      # one JSON line per .txt file
npm run scanProofs -- path/to/proofs/ --compare before.jsonl   # diff against a baseline
npm run typecheck
```

## HTTP service

```bash
npm run checker-server            # PORT defaults to 4000
curl localhost:4000/health
curl -X POST localhost:4000/check -H 'Content-Type: application/json' \
  -d '{"text": "<proof source>"}'
```

Response: `{ "isCorrect": bool, "issues": [...] }`, or
`{ "isCorrect": false, "errors": [...] }` when the proof fails to parse.

## Docker

```bash
docker compose up --build         # service on http://localhost:4000

# one-off CLI check against a mounted directory
docker build -t geo-checker-ts .
docker run --rm -v "$PWD/proofs:/proofs:ro" geo-checker-ts \
  npm run --silent checkProof -- /proofs/foo.txt
```

## Tests

Proof files aren't included in this repo. The regression suite runs against any
directory of proofs whose first line is `// pass`, `// fail on step N`, or
`// fail incomplete`:

```bash
PROOFS_DIR=../ender/src/checker/proofs npm test
```

With no `PROOFS_DIR` set (and no `src/checker/proofs/`), the suite is skipped.
