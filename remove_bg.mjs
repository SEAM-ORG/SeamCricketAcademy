import { Jimp } from 'jimp';

async function main() {
  console.log('Reading image...');
  const image = await Jimp.read('public/assets/images/bowling_machine_emoji.png');

  console.log('Processing pixels...');
  image.scan(0, 0, image.bitmap.width, image.bitmap.height, function (x, y, idx) {
    // Get the colors
    const red = this.bitmap.data[idx + 0];
    const green = this.bitmap.data[idx + 1];
    const blue = this.bitmap.data[idx + 2];
    const alpha = this.bitmap.data[idx + 3];

    // If it's a black pixel (or very close to black), make it transparent
    // Threshold of 30 should cover the near-black compression artifacts
    if (red < 30 && green < 30 && blue < 30) {
      this.bitmap.data[idx + 3] = 0; // Set alpha to 0
    }
  });

  console.log('Writing output...');
  await image.write('public/assets/images/bowling_machine_transparent.png');
  console.log('Done!');
}

main().catch(console.error);
