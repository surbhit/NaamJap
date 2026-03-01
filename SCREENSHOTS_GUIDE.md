# How to Add Screenshots to the Website

## Quick Steps:

1. **Get your screenshots** from:
   - Your Instagram account: https://www.instagram.com/naamjhap
   - Or take new screenshots directly from your app

2. **Save the images** to: `assets/images/screenshots/`

3. **Name them exactly as follows:**
   - `choose_mantra.png` - Choose Your Mantra screen
   - `my_mantras.png` - My Mantras screen  
   - `your_journey.png` - Your Journey analytics screen
   - `mala_completion.png` - Mala Completion screen
   - `spiritual_interface.png` - Spiritual interface/home screen
   - `progress_counter.png` - Progress Counter screen

4. **After adding images**, run:
   ```bash
   flutter pub get
   flutter run -d web-server --web-port 8080
   ```

## Image Tips:
- Use PNG format for best quality
- Recommended size: 1080x1920 pixels (mobile screenshot size)
- Keep file sizes under 2MB for fast loading
- Images will automatically display on the `/naamjap` page

## Current Status:
The website is set up to display screenshots. If images are not found, placeholder graphics will be shown automatically.



