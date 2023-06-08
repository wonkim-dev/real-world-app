import { Injectable } from '@nestjs/common';
import { toNumber } from 'lodash';
import { CipherCCMTypes, createCipheriv, createDecipheriv, randomBytes } from 'crypto';
import { EncryptedData } from './auth.model';

@Injectable()
export class EncryptionService {
  private readonly algorithm: string;
  private readonly cipherKey: Buffer;
  private readonly cipherIvBytes: number;
  private readonly authTagLength: number;

  constructor() {
    this.algorithm = process.env.ENCRYPTION_ALGORITHM;
    this.cipherKey = Buffer.from(process.env.ENCRYPTION_CIPHER_KEY_HEX, 'hex');
    this.cipherIvBytes = toNumber(process.env.ENCRYPTION_CIPHER_IV_BYTES);
    this.authTagLength = toNumber(process.env.ENCRYPTION_AUTH_TAG_LENGTH);
  }

  encrypt(text: string): EncryptedData {
    const iv = randomBytes(this.cipherIvBytes);
    const cipher = createCipheriv(this.algorithm as CipherCCMTypes, this.cipherKey, iv, {
      authTagLength: this.authTagLength,
    });
    const encryptedText = Buffer.concat([cipher.update(text, 'utf8'), cipher.final()]);
    const authTag = cipher.getAuthTag();
    return { encryptedTextHex: encryptedText.toString('hex'), ivHex: iv.toString('hex'), authTagHex: authTag.toString('hex') };
  }

  decrypt(encryptedData: EncryptedData): string {
    const iv = Buffer.from(encryptedData.ivHex, 'hex');
    const authTag = Buffer.from(encryptedData.authTagHex, 'hex');
    const decipher = createDecipheriv(this.algorithm as CipherCCMTypes, this.cipherKey, iv, {
      authTagLength: this.authTagLength,
    });
    decipher.setAuthTag(authTag);
    const decryptedText = Buffer.concat([decipher.update(encryptedData.encryptedTextHex, 'hex'), decipher.final()]);
    return decryptedText.toString();
  }
}
