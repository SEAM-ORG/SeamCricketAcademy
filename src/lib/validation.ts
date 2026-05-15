/**
 * Validates if a string is a basic email format.
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/;
  return emailRegex.test(email);
}

/**
 * Validates if a URL is a safe WhatsApp link.
 */
export function isValidWhatsApp(url: string): boolean {
  try {
    const parsed = new URL(url);
    return (
      parsed.protocol === 'https:' &&
      (parsed.hostname === 'wa.me' || parsed.hostname === 'api.whatsapp.com')
    );
  } catch {
    return false;
  }
}

/**
 * Checks if a string is safe to be used in a URL (prevents javascript: etc.)
 */
export function isSafeUrl(url: string, allowedProtocols: string[] = ['https:', 'mailto:', 'tel:']): boolean {
  try {
    const parsed = new URL(url);
    return allowedProtocols.includes(parsed.protocol);
  } catch {
    // If it's a relative path or something that doesn't parse as a full URL,
    // we might want to be careful. But for mailto: and tel: they should parse if they have the prefix.
    return false;
  }
}
