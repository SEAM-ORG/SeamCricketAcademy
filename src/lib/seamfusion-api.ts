/**
 * SeamFusion API Client
 *
 * Build-time data fetching for Astro components.
 * All functions are safe — they never throw, returning null on failure.
 *
 * Environment variables (set as GitHub repository variables):
 *   PUBLIC_ACADEMY_ID — Firestore academy document ID
 *   PUBLIC_API_URL    — Cloud Functions base URL
 */

/**
 * Helper to safely get environment variables in both browser and Node.js.
 * Uses literal access for Vite static replacement.
 */
function getApiUrl(): string {
  try {
    return import.meta.env.PUBLIC_API_URL || '';
  } catch {
    return (globalThis as any).process?.env?.PUBLIC_API_URL || '';
  }
}

function getAcademyId(): string {
  try {
    return import.meta.env.PUBLIC_ACADEMY_ID || '';
  } catch {
    return (globalThis as any).process?.env?.PUBLIC_ACADEMY_ID || '';
  }
}

type Section = 'coaches' | 'programs' | 'branding' | 'gallery' | 'content';

export interface AcademyData {
  branding?: Record<string, unknown>;
  coaches?: Array<Record<string, unknown>>;
  programs?: Array<Record<string, unknown>>;
  gallery?: Array<Record<string, unknown>>;
  content?: Record<string, unknown>;
}

/**
 * Fetch public academy data at build time.
 * Returns null if the API is unreachable or env vars are missing.
 */
export async function fetchAcademyData(sections?: Section[]): Promise<AcademyData | null> {
  const apiUrl = getApiUrl();
  const academyId = getAcademyId();

  if (!apiUrl || !academyId) return null;

  try {
    const params = new URLSearchParams({ academyId });
    if (sections?.length) {
      params.set('sections', sections.join(','));
    }

    const res = await fetch(`${apiUrl}/getPublicAcademyData?${params}`, {
      signal: AbortSignal.timeout(10_000),
    });

    if (!res.ok) return null;
    return (await res.json()) as AcademyData;
  } catch {
    console.warn('[SeamFusion] API fetch failed — using static fallback data');
    return null;
  }
}

// ── Build-time cache for website content ──
// Multiple Astro components can call fetchWebsiteContent() and share
// a single API request during the same build.

let _contentCache: Record<string, unknown> | null | undefined;

/**
 * Fetch editable website content (hero, about, testimonials, etc.).
 * Cached per build — safe to call from every component.
 * Returns null if unavailable; callers should fall back to static data.
 */
export async function fetchWebsiteContent(): Promise<Record<string, unknown> | null> {
  if (_contentCache !== undefined) return _contentCache;
  const data = await fetchAcademyData(['content']);
  _contentCache = (data?.content as Record<string, unknown>) ?? null;
  return _contentCache;
}
