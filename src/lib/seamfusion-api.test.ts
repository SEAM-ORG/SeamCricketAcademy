import assert from 'node:assert';
import { after, before, describe, mock, test } from 'node:test';

// Mock process.env before importing the module
process.env.PUBLIC_API_URL = 'https://api.example.com';
process.env.PUBLIC_ACADEMY_ID = 'test-academy-id';

import { fetchAcademyData } from './seamfusion-api.ts';

describe('fetchAcademyData', () => {
  const ORIGINAL_FETCH = globalThis.fetch;

  after(() => {
    globalThis.fetch = ORIGINAL_FETCH;
  });

  test('successfully fetches academy data', async () => {
    const mockData = { content: { hero: 'Welcome' } };

    globalThis.fetch = mock.fn(async (url: string) => {
      const parsedUrl = new URL(url);
      assert.strictEqual(parsedUrl.origin, 'https://api.example.com');
      assert.strictEqual(parsedUrl.pathname, '/getPublicAcademyData');
      assert.strictEqual(parsedUrl.searchParams.get('academyId'), 'test-academy-id');

      return {
        ok: true,
        json: async () => mockData,
      } as Response;
    });

    const result = await fetchAcademyData();
    assert.deepStrictEqual(result, mockData);
  });

  test('returns null when API response is not OK', async () => {
    globalThis.fetch = mock.fn(async () => {
      return {
        ok: false,
      } as Response;
    });

    const result = await fetchAcademyData();
    assert.strictEqual(result, null);
  });

  test('returns null and warns when fetch throws (catch block)', async () => {
    const consoleSpy = mock.fn();
    const originalWarn = console.warn;
    console.warn = consoleSpy;

    globalThis.fetch = mock.fn(async () => {
      throw new Error('Network failure');
    });

    try {
      const result = await fetchAcademyData();
      assert.strictEqual(result, null);
      assert.strictEqual(consoleSpy.mock.callCount(), 1);
      assert.ok(
        (consoleSpy.mock.calls[0].arguments[0] as string).includes('[SeamFusion] API fetch failed'),
      );
    } finally {
      console.warn = originalWarn;
    }
  });

  test('returns null when environment variables are missing', async () => {
    const savedUrl = process.env.PUBLIC_API_URL;
    process.env.PUBLIC_API_URL = '';

    try {
      const result = await fetchAcademyData();
      assert.strictEqual(result, null);
    } finally {
      process.env.PUBLIC_API_URL = savedUrl;
    }
  });

  test('correctly passes sections as query parameters', async () => {
    globalThis.fetch = mock.fn(async (url: string) => {
      const parsedUrl = new URL(url);
      assert.strictEqual(parsedUrl.searchParams.get('sections'), 'coaches,programs');
      return {
        ok: true,
        json: async () => ({}),
      } as Response;
    });

    await fetchAcademyData(['coaches', 'programs']);
  });
});
