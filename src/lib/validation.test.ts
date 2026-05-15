import { describe, it } from 'node:test';
import assert from 'node:assert';
import { isValidEmail, isValidWhatsApp } from './validation.ts';

describe('Validation Utilities', () => {
  describe('isValidEmail', () => {
    it('should return true for valid emails', () => {
      assert.strictEqual(isValidEmail('test@example.com'), true);
      assert.strictEqual(isValidEmail('user.name@domain.co.uk'), true);
    });

    it('should return false for invalid emails', () => {
      assert.strictEqual(isValidEmail('invalid-email'), false);
      assert.strictEqual(isValidEmail('test@'), false);
      assert.strictEqual(isValidEmail('@example.com'), false);
      assert.strictEqual(isValidEmail('test@example'), false);
      assert.strictEqual(isValidEmail('test@example..com'), false);
      assert.strictEqual(isValidEmail('javascript:alert(1)'), false);
    });
  });

  describe('isValidWhatsApp', () => {
    it('should return true for valid WhatsApp links', () => {
      assert.strictEqual(isValidWhatsApp('https://wa.me/918951191375'), true);
      assert.strictEqual(isValidWhatsApp('https://api.whatsapp.com/send?phone=918951191375'), true);
    });

    it('should return false for invalid WhatsApp links', () => {
      assert.strictEqual(isValidWhatsApp('http://wa.me/918951191375'), false); // Insecure
      assert.strictEqual(isValidWhatsApp('https://example.com'), false);
      assert.strictEqual(isValidWhatsApp('javascript:alert(1)'), false);
      assert.strictEqual(isValidWhatsApp('wa.me/918951191375'), false); // No protocol
    });
  });
});
