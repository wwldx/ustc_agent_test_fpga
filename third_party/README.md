# Third-Party Source Handling

Do not casually copy external repositories into this repository.

Preferred options:

1. Link to upstream repositories in paper notes.
2. Use a Git submodule only when the exact upstream revision must be pinned.
3. Use a fork when local modifications need to be shared.
4. Keep large downloaded assets, model weights, generated waveforms, and PDFs outside Git.

## Candidate Upstreams

- VerilogCoder: https://github.com/NVlabs/VerilogCoder
- ChipMATE: https://github.com/zhongkaiyu/ChipMATE
- LEGO: https://github.com/loujc/LEGO-An-LLM-Skill-Based-Front-End-Design-Generation-Platform
- MAGE: https://github.com/stable-lab/MAGE

## If Adding A Submodule

Record:

- exact upstream URL;
- commit hash;
- why a submodule is needed instead of a source link;
- commands used to initialize and update it.
