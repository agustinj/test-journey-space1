# TestJourney — Environment Starter Kit (Week 1)

This repo only sets up the environment — it's not the course project itself. On purpose, there's no `package.json` and no tests yet: that's Week 1 content, and each student builds it together with Alex, the Tech Lead. What this repo takes care of is making sure Node, npm, and Playwright's browsers are already installed and working, and that the practice site under test is already up and running — so nobody has to configure anything on their own machine.

## Try it yourself (nothing to install)

1. Go to this repo's page on github.com.
2. Click the green "Code" button → "Codespaces" tab → "Create codespace on main".
3. Wait about a minute. A full VS Code opens in the browser — not a lightweight version, the real thing.
4. Open the integrated terminal (Terminal → New Terminal, or Ctrl+` / Cmd+`) and run:

```
node -v
echo $PLAYWRIGHT_BROWSERS_PATH
ls $PLAYWRIGHT_BROWSERS_PATH
curl -I http://localhost:4200
```

If you see a Node version, a path followed by folders like `chromium-xxxx`/`firefox-xxxx`/`webkit-xxxx`, and an `HTTP/1.1 200 OK` from the last command, the environment is healthy — Playwright's browsers are already installed, and the practice site (self-hosted, no external dependencies) is already running on port 4200. This is exactly what any student will see, no matter what computer they're using.

When you're done looking around, you can just close the tab. An idle Codespace stops itself automatically after a while (it won't keep burning your free hours while you're not using it), and the 120 free hours a month on a personal GitHub account are more than enough to test this, and for a handful of students to complete all 4 weeks.

## Get your own copy

Since this repo is set up as a GitHub Template, there's no manual setup needed: on this repo's page, click "Use this template" → "Create a new repository", give it a name, and you're done. GitHub creates a fresh copy with its own first commit — no local git commands required.

## What's next

Once you've confirmed this works, the next step is for each student to do exactly the same thing: create their own copy of this repo from the template, then open a Codespace on it. From there, the conversation with Alex begins, and that's where the framework actually gets built — checkpoint 1 (repo initialized, first commit) is already taken care of by this same process.
