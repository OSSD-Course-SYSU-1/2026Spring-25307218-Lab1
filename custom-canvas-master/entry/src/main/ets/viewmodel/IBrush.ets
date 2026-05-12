/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export interface IBrush {
  /**
   * When the contacts are in contact.
   */
  down(path: Path2D, x: number, y: number): void;

  /**
   * When the contact moves.
   */
  move(path: Path2D, x: number, y: number): void;

  /**
   * When the contact stops.
   */
  up(path: Path2D, x: number, y: number): void;
}

export default class NormalBrush implements IBrush {
  down(path: Path2D, x: number, y: number): void {
    path.moveTo(x, y);
  }

  move(path: Path2D, x: number, y: number): void {
    path.lineTo(x, y);
  }

  up(path: Path2D, x: number, y: number): void {}

}

export class FountainPenPoint {
  x: number;
  y: number;
  velocity: number;

  constructor(x: number, y: number, velocity: number) {
    this.x = x;
    this.y = y;
    this.velocity = velocity;
  }
}

export class FountainPenBrush implements IBrush {
  public points: FountainPenPoint[] = [];
  private lastX: number = 0;
  private lastY: number = 0;
  private lastTime: number = 0;
  private smoothVelocity: number = 0;
  private readonly SMOOTH_FACTOR: number = 0.3;

  down(path: Path2D, x: number, y: number): void {
    path.moveTo(x, y);
    this.points = [];
    this.points.push(new FountainPenPoint(x, y, 0));
    this.lastX = x;
    this.lastY = y;
    this.lastTime = Date.now();
    this.smoothVelocity = 0;
  }

  move(path: Path2D, x: number, y: number): void {
    path.lineTo(x, y);
    const now = Date.now();
    const dt = now - this.lastTime;
    const dx = x - this.lastX;
    const dy = y - this.lastY;
    const dist = Math.sqrt(dx * dx + dy * dy);
    const rawVelocity = dt > 0 ? dist / dt : 0;
    this.smoothVelocity = this.SMOOTH_FACTOR * rawVelocity + (1 - this.SMOOTH_FACTOR) * this.smoothVelocity;
    this.points.push(new FountainPenPoint(x, y, this.smoothVelocity));
    this.lastX = x;
    this.lastY = y;
    this.lastTime = now;
  }

  up(path: Path2D, x: number, y: number): void {}

}