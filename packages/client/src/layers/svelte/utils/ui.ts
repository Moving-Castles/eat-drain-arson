export function shortenAddress(s: string) {
  return s ? s.slice(0, 8) + "..." + s.slice(-8) : "";
}

export function addressToColor(address: string): string {
  let hash = address;
  // Take the last 6 characters of the hash
  hash = hash.slice(-6);
  // Prefix with '#' to create a valid hex color code
  return "#" + hash;
}

export function getRandomInt(min: number, max: number) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

export const DEV = false;
