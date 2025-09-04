# Media-Agents

**Script-to-Cinematic Pipeline with Flux, Kling & ElevenLabs**

An n8n automation that turns a short premise into a 1–2 minute narrative VO cinematic with a consistent visual style. It writes the script, generates shot images, creates movement, synthesizes voiceover, and exports assets to Google Drive. It can also be used to generate B-roll for longer edits.

**What it does**
1. Story synthesis: LLM creates a voiceover and structured shot list (scene, movement, sound design).
2. Look & feel: Flux generates consistently styled keyframes per shot.
3. Motion: Kling turns keyframes + movement prompts into cinematic clips.
4. Voiceover: ElevenLabs produces narration aligned to the script.
5. Sound Effects: ElevenLabs produces SFX aligned to the script.
6. Asset management (optional): Writes thumbnails/metadata to Google Sheets and uploads images, VO, and video to Google Drive with clean, shot-based filenames.

**Example Video**
[![Video Thumbnail](https://github.com/adam-t-gensler/media-agents/blob/main/assets/UTHSC_Gensler_Meticulous.png)](https://vimeo.com/1103280330/4768adf4c8)

**When to use it**
- Fast ideation for 1–2 minute narrative pieces with a cohesive style.
- B-roll generation to intercut with live action or archival footage.
- Pitch films, animatics, and visual explorations where continuity isn’t critical.

⚠️ Not intended to maintain character continuity across runs, nor to recreate specific locations with high fidelity.

**Quick start**
1. n8n: Import the provided workflow JSON(s).
2. Credentials: Add API keys/creds in n8n:
   * LLM_API_KEY (your model provider for script generation)
   * FAL_API_KEY (Flux, Kling, ElevenLabs via fal.ai)
   * Google: OAuth credentials for Sheets/Drive
3. (Optional) Google Sheet named Premise with headers:
   * Duration (Seconds), Number of Shots, Premise, Location, Charcter(s)
4. Run the “Script → Images → Motion → VO → Upload” pipeline.
5. Find assets in your configured Drive folder.

The structure and naming convention of the Google Sheets tabs, columns, and cells must match the workflow exactly. The Google Drive folders must also follow the naming convention of the workflow.

Media Agent Output<br/>
├── Footage<br/>
├── Images<br/>
├── Sound Effects<br/>
├── Voiceover<br/>
