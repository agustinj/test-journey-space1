# TestJourney — Starter de entorno (Semana 1)

Esto es solo el **entorno**, no el proyecto. A propósito no tiene
`package.json` ni tests — eso es contenido de la Semana 1 y lo arma cada
alumno junto con Alex (el Tech Lead). Lo único que resuelve este repo
es que Node, npm y los navegadores de Playwright ya estén instalados y
funcionando, sin que nadie tenga que configurar nada en su compu.

## Cómo probarlo vos mismo (sin instalar nada)

1. Subí este repo a GitHub (instrucciones abajo si no lo hiciste todavía).
2. Entrá al repo en github.com.
3. Botón verde **"Code"** → pestaña **"Codespaces"** → **"Create codespace on main"**.
4. Esperá alrededor de un minuto. Se abre un VSCode completo, corriendo en
   el navegador — no es una versión liviana, es VSCode de verdad.
5. Abrí la terminal integrada (`Ctrl+ñ` o `Ctrl+\``, o Terminal → New
   Terminal) y corré:
   ```
   node -v
   npx playwright --version
   ```
   Si ves versiones de ambos sin errores, el entorno está sano — así
   arrancaría cualquier alumno, sin importar qué compu tenga.

Cuando termines de mirarlo, podés simplemente cerrar la pestaña. Un
Codespace sin actividad se detiene solo después de un rato (no sigue
gastando tus horas gratis mientras no lo estés usando), y las 120 horas
gratis por mes de tu cuenta personal de GitHub alcanzan de sobra para
probar esto y para que un puñado de alumnos completen las 4 semanas.

## Cómo subir este repo a GitHub (si no tenés uno todavía)

1. Bajá y descomprimí el zip que te mandé.
2. En github.com, creá un repo nuevo, vacío (sin README ni .gitignore
   generado por GitHub, para no pisar lo que ya está armado acá).
3. Desde la carpeta descomprimida, en una terminal:
   ```
   git init
   git add .
   git commit -m "Entorno base de TestJourney - Semana 1"
   git branch -M main
   git remote add origin <URL-de-tu-repo-nuevo>
   git push -u origin main
   ```
4. Recargá la página del repo en GitHub — ahí ya podés usar el botón
   "Code" → "Codespaces" como en el paso anterior.

## Qué sigue

Una vez que confirmes que esto funciona, el paso siguiente es que cada
alumno haga exactamente lo mismo (crear su propio Codespace a partir de
este mismo repo, o de un fork), y ahí sí arranca la conversación con
Marcos para construir el framework — checkpoint 1 del runbook (repo
inicializado, primer commit) prácticamente ya está resuelto por este
mismo proceso.
