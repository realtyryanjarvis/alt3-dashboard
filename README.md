# Alt3 Smart Homes — Proposal Generator

Generate beautiful, branded client proposal pages from a simple JSON data file.

---

## Quick Start

1. **Copy the sample data file** into a new proposal folder:
   ```bash
   mkdir -p proposals/your-address-slug
   cp _template/sample-data.json proposals/your-address-slug/data.json
   ```

2. **Edit the data file** with your client's info:
   ```bash
   open proposals/your-address-slug/data.json   # or use any text editor
   ```

3. **Generate the proposal:**
   ```bash
   ./generate-proposal.sh proposals/your-address-slug/data.json
   ```

4. The output lands at `proposals/your-address-slug/client-experience.html` and is automatically committed + pushed to git.

---

## File Structure

```
alt3-dashboard/
├── _template/
│   ├── client-experience-template.html   # Master template (don't edit directly)
│   └── sample-data.json                  # Example with 1240 Paddock values
├── proposals/
│   ├── 1240-paddock/
│   │   ├── data.json                     # Project data
│   │   └── client-experience.html        # Generated output
│   └── your-new-project/
│       ├── data.json                     # ← Fill this in
│       └── client-experience.html        # ← Auto-generated
├── generate-proposal.sh                  # The generator script
└── README.md                             # This file
```

---

## Data Fields Reference

| Field | Description | Example |
|-------|-------------|---------|
| `PAGE_TITLE` | Browser tab title | `"1240 Paddock Avenue — Alt3 Smart Homes"` |
| `CLIENT_NAME` | Client's name (shown in nav badge) | `"Jeffery Davis"` |
| `ADDRESS` | Street address | `"1240 Paddock Avenue"` |
| `CITY` | City | `"Charlotte"` |
| `BUILDER_NAME` | General contractor name | `"Keen Building Company"` |
| `PROCESS_STEP_3_NOTE` | Step 3 caption in the process timeline | `"Coordinated with Keen Building Company's timeline"` |
| `CTA_SUBJECT` | URL-encoded email subject for the CTA button | `"1240%20Paddock%20Avenue%20%E2%80%94%20Let%27s%20Go"` |
| `AUDIO_ZONES` | Number shown in the audio section stat card | `"14"` |
| `PDF_LINK` | Link to the full PDF/HTML proposal. **Leave empty to hide the button.** | `"../1240-paddock-complete.html"` |
| `SECTION_A_NAME` | Section A heading | `"Lighting Control"` |
| `SECTION_A_PRICE` | Section A price | `"$121,974.35"` |
| `SECTION_A_NOTE` | Small note under the price | `"Material + Engineering + 5% Project Enhancements"` |
| `SECTION_A_ITEMS` | HTML `<li>` bullet items for Section A card | `"<li>Lutron HomeWorks QSX processors</li>..."` |
| `SECTION_A_DETAIL_HTML` | Full inner HTML of the Section A expandable panel | *(see sample-data.json)* |
| `SECTION_B_NAME` | Section B heading | `"Smart Home & A/V"` |
| `SECTION_B_PRICE` | Section B price | `"$113,451.61"` |
| `SECTION_B_NOTE` | Small note under the price | `"Fully installed + 5% Project Enhancements"` |
| `SECTION_B_ITEMS` | HTML `<li>` bullet items for Section B card | *(see sample-data.json)* |
| `SECTION_B_DETAIL_HTML` | Full inner HTML of the Section B expandable panel | *(see sample-data.json)* |
| `SECTION_C_NAME` | Section C heading | `"Lutron Motorized Shading"` |
| `SECTION_C_PRICE` | Section C price | `"~$39,000"` |
| `SECTION_C_NOTE` | Small note under the price | `"Budgetary estimate — 26 windows, includes installation"` |
| `SECTION_C_ITEMS` | HTML `<li>` bullet items for Section C card | *(see sample-data.json)* |
| `SECTION_C_DETAIL_HTML` | Full inner HTML of the Section C expandable panel | *(see sample-data.json)* |

---

## Tips

### Hiding the PDF button
Leave `PDF_LINK` as an empty string `""` or omit it entirely:
```json
{ "PDF_LINK": "" }
```
The "View Complete Proposal" button will be hidden automatically.

### Section detail panels
The `SECTION_X_DETAIL_HTML` fields accept raw HTML. Copy the structure from `sample-data.json` as a starting point and modify the room names, line items, and totals. The template wraps each panel with a header and a total footer automatically — you just provide the inner content.

### URL-encoding the CTA subject
The `CTA_SUBJECT` is injected directly into a `mailto:` href. Spaces should be `%20`, em dashes `%E2%80%94`, apostrophes `%27`, etc. Use any online URL encoder to generate this.

### Requirements
- `jq` must be installed: `brew install jq`
- `git` remote must be configured with push access

---

## Example: New Project

```bash
mkdir -p proposals/500-oak-street
cp _template/sample-data.json proposals/500-oak-street/data.json
# Edit proposals/500-oak-street/data.json ...
./generate-proposal.sh proposals/500-oak-street/data.json
```

Output: `proposals/500-oak-street/client-experience.html` — committed and pushed automatically.
