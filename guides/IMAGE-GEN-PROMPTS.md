# Image Generation Prompt Guide

_How to get great results from your agent's image generation skill._

---

## How It Works

Your agent can generate images using AI models (like DALL-E or Flux). Just describe what you want in natural language and it will create it.

**Example:**
> "Generate an image of a golden retriever wearing sunglasses, sitting on a beach at sunset, photorealistic style"

---

## Prompt Structure

Great prompts follow this pattern:

```
[Subject] + [Action/Pose] + [Setting/Background] + [Style] + [Details]
```

**Examples:**

| Prompt | Why It Works |
|--------|-------------|
| "A cozy coffee shop interior, warm lighting, plants on shelves, watercolor style" | Clear subject + mood + style |
| "Professional headshot of a woman in business attire, studio lighting, neutral background, photorealistic" | Specific type + lighting + background + style |
| "Isometric 3D render of a tiny home office with a desk, computer, and bookshelf, pastel colors" | Clear perspective + details + color palette |
| "Minimalist logo design for a tech startup called 'Nova', dark background, geometric shapes, clean lines" | Purpose + name + aesthetic direction |

---

## Style Keywords That Work

### Photography Styles
- Photorealistic, studio photography, portrait photography
- Macro photography, aerial/drone shot, long exposure
- Film photography, 35mm film, Polaroid style
- Golden hour lighting, dramatic lighting, soft lighting

### Art Styles
- Watercolor, oil painting, digital art, concept art
- Pixel art, vector illustration, line drawing
- Comic book style, anime/manga style
- Minimalist, abstract, surrealist

### 3D & Design
- 3D render, isometric, low poly
- Clay render, glass morphism, neon
- Blueprint style, wireframe, technical drawing

### Mood & Atmosphere
- Cinematic, moody, ethereal, vibrant
- Dark and atmospheric, bright and cheerful
- Retro/vintage, futuristic, cyberpunk

---

## Tips for Better Results

1. **Be specific.** "A dog" gives generic results. "A corgi puppy sleeping on a red velvet couch" gives great results.

2. **Specify the style.** Always include a style keyword. Without one, results are unpredictable.

3. **Mention lighting.** Lighting changes everything. "Warm golden hour lighting" vs "harsh fluorescent lighting" produce completely different images.

4. **Include composition.** "Close-up", "wide angle", "bird's eye view", "centered" help control framing.

5. **Use negative guidance.** Tell the model what you don't want: "no text", "no watermarks", "no people in the background."

6. **Iterate.** First result not perfect? Refine: "Same image but make the sky more orange and add a few clouds."

---

## Common Use Cases

### Social Media Graphics
> "Modern Instagram post graphic for a tech newsletter called 'The Metagame', dark theme with electric blue accents, abstract neural network pattern, clean and professional, 1080x1080"

### Blog/Article Headers
> "Wide banner image of a futuristic cityscape at dusk, cyberpunk aesthetic, neon signs, reflection on wet streets, 16:9 aspect ratio"

### Product Mockups
> "Realistic iPhone mockup showing a fitness app dashboard, clean UI, white background, studio lighting"

### Avatars/Profile Pictures
> "Stylized digital avatar of a robot with friendly eyes, geometric design, purple and teal color scheme, circular crop"

### Presentation Slides
> "Clean infographic-style illustration showing 3 connected steps, modern business style, blue and white palette, no text"

---

## Aspect Ratios

Specify these when the default square doesn't work:

- **Square (1:1):** Social media posts, profile pictures
- **Landscape (16:9):** Blog headers, presentations, desktop wallpapers
- **Portrait (9:16):** Phone wallpapers, stories, TikTok thumbnails
- **Wide (21:9):** Ultra-wide banners, cinematic shots

Just add the ratio to your prompt: "...landscape format, 16:9 aspect ratio"
