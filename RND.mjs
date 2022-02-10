'use strict';

/**
 * @module RND
 * @class
 */
export class RND {
  /**
   * @static
   * @private
   * @description The seed
   * @type {number}
   */
  static #seed = 0;
  /**
   * @static
   * @private
   * @description The modulus
   * @type {number}
   */
  static #mod = 2147483647;

  /**
   * @static
   * @description Sets the seed
   * @param {number} value - The value to set the seed to
   */
  static setSeed(value) {
    RND.#seed = value;
  }

  /**
   * @static
   * @description Returns the seed
   * @returns {number} The seed
   */
  static getSeed() {
    return RND.#seed;
  }

  /**
   * @static
   * @description Returns the next random value
   * @returns {number} The next random value
   */
  static random() {
    RND.#seed ^= RND.#seed << 21;
    RND.#seed ^= RND.#seed >>> 35;
    RND.#seed ^= RND.#seed << 4;

    if (RND.#seed < 0) {
      RND.#seed &= RND.#mod;
    }

    return ~~(RND.#seed / RND.#mod * 255);
  }
}
