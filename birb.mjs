'use strict';

import { readFile } from 'fs/promises';

/**
 * @module Birb
 * @class
 */
export class Birb {
  /**
   * @static
   * @private
   * @description The table containing ID to Old/New
   * @type {object}
   */
  static #full = {};
  /**
   * @static
   * @private
   * @description The table used to look up obfuscated values to get their ID
   * @type {object}
   */
  static #newToId = {};

  /**
   * @static
   * @async
   * @description Initializes the tables that we need
   */
  static async init() {
    Birb.#full = JSON.parse(await readFile('data/decrypted_secure_map(table_full).json'));
    Birb.#newToId = JSON.parse(await readFile('data/decrypted_secure_map(table_new_to_id).json'));
  }

  /**
   * @static
   * @param {string} value - The obfuscated value to look up
   * @returns {string} The plaintext value
   */
  static lookup(value) {
    return Birb.#full[Birb.#newToId[value]].Old; //? We only need 'Old' here
  }
}
