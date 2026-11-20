# Skills for Cancer Scientists & Bioinformaticians

> [!WARNING]
> This repository is in early development and is not yet ready for use.

A collection of skills that aim to:

1. Make AI-accelerated cancer bioinformatics less dodgy.
2. Speed up development of quality scientific software in R and Rust.
3. Help users learn bioinformatics concepts instead of abstracting away both methods and data.


## Installation

Skills are grouped under [`skills/`](skills/) into [data visualisation](skills/datavis/) and [software development](skills/softwaredevelopment/). Each skill has its own folder containing `SKILL.md` and any supporting files. The installer copies each skill folder directly into `~/.agents/skills/` by default.

**Automatic Installation:**

Open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/selkamand/skills/main/install.sh | bash
```

To install into a different skills directory, pass it as the first argument:

```bash
curl -fsSL https://raw.githubusercontent.com/selkamand/skills/main/install.sh | bash -s -- /path/to/skills
```

<details>

<summary>**Manual Installation:**</summary>

To install a skill from a local copy of this repository, copy its whole folder so its references remain available. For example:

```bash
mkdir -p ~/.agents/skills
cp -R skills/datavis/oncoplot ~/.agents/skills/
```

The [oncoplot skill](skills/datavis/oncoplot/SKILL.md) will then be at `~/.agents/skills/oncoplot/SKILL.md`. For a project-specific installation, copy the folder to that project's `.agents/skills/` directory instead.

</details>

## Rationale

### Safer bioinformatics for non-bioinformaticians

I expect the vast majority of published cancer bioinformatics will very soon be done by experimentalists who don't self-identify as bioinformaticians. 
At first, that made me nervous. 
Retractions in cancer literature show it's hard for reviewers to spot invalid bioinformatics from the outside, and AI empowerment will likely flood the literature with dodgy analyses. 
Still, experimentalists embracing AI for computational work will accelerate important discoveries.

This means, as computational biologists, we either equip our colleagues to do bioinformatics more safely or do nothing and hope the models get good enough that abstracting over data and methods causes minimal damage. 
Additionally, we can use these AI skills to educate users about key concepts and make the important analytical decisions explicit instead of abstracting them away. 

### Better bioinformatic tools

Bioinformatics software is notoriously terrible. IMHO, great software requires:

1. A deep understanding of the domain.
2. A sense of the long-term cost of implementation decisions.
3. Easy access for its intended users.

AI can (maybe) help with all 3 of these.

#### Domain Knowledge

Searching for relevant literature is far easier now. Deep research from OpenAI is pretty phenomenal. 
Free tools like SciSpace search are also pretty good.
These tools make it far easier to find the essential literature you need to read to build domain knowledge.

For me, search has been a killer application for AI but only when done through these dedicated literature search modes.

Note that asking LLMs to summarise the knowledge across multiple papers can be pretty hit or miss. 

#### Long-term costs of implementation decisions

Should I take this dependency? Should I pull this functionality out into its own library? What language should I write this program in?

It's possible to write skills that help different user personas make this decision. 
For example, a research scientist writing scripts to support their research analyses probably doesn't need to care about complex dependency trees or breaking API changes. 
For someone writing software others will depend on, much more care is required.

#### Accessibility 

AI can help increase accessibility for two audiences:

**Non-programmers:**

Good docs and an AI skill might let people use a library or CLI without a whole GUI. 
Building, deploying, and securing a GUI is a different skill set from writing a great library or CLI, so this could be a real boon for the field.

**Bioinformaticians:**

Instead of picking one language to implement our tools in (usually Python, R, Go, or Julia), AI tools could lower the barriers to writing the core logic in C or Rust and building bindings in many different higher-level languages. 
This could help reduce reimplementations while improving performance of our tools. 

I'm not advocating for vibe-coded “rewrite it in Rust” projects. 
It's more that I think LLMs could help people learn the basics of these lower-level languages and check that APIs in different languages return the same results.


Even if you're just writing a plain old R package, where you publish matters too: GitHub, R-universe, Bioconductor, and CRAN have different expectations that affect how you build it. 
I plan to add skills that help scientists make that choice and, for example, build their first CRAN-compatible package.
These skills can include strong pushes *not* to submit to repositories like CRAN or Bioconductor unless users are willing to maintain their packages for the long haul.
