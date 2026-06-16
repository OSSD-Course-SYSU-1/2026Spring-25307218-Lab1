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

import DrawPath, { ShapeDraw, TextDraw, DrawPathData,
  TouchPointData, FountainPenPointData } from './IDraw';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class DrawInvoker {
  private drawPathList: DrawPath[] = [];
  private redoList: DrawPath[] = [];

  add(command: DrawPath): void {
    this.drawPathList.push(command);
    this.redoList = [];
  }

  clear(): void {
    this.drawPathList = [];
    this.redoList = [];
  }

  undo(): void {
    if (this.drawPathList.length > 0) {
      let undo: DrawPath = this.drawPathList.pop()!;
      this.redoList.push(undo);
    }
  }

  redo(): void {
    if (this.redoList.length > 0) {
      let redoCommand: DrawPath = this.redoList.pop()!;
      this.drawPathList.push(redoCommand);
    }
  }

  execute(context: CanvasRenderingContext2D): void {
    for (let i = 0; i < this.drawPathList.length; i++) {
      this.drawPathList[i].draw(context);
    }
  }

  canRedo(): boolean {
    return this.redoList.length > 0;
  }

  canUndo(): boolean {
    return this.drawPathList.length > 0;
  }

  removeAt(index: number): void {
    if (index >= 0 && index < this.drawPathList.length) {
      this.drawPathList.splice(index, 1);
      this.redoList = [];
    }
  }

  getAt(index: number): DrawPath | null {
    if (index >= 0 && index < this.drawPathList.length) {
      return this.drawPathList[index];
    }
    return null;
  }

  getCount(): number {
    return this.drawPathList.length;
  }

  findShapeAt(x: number, y: number): number {
    for (let i = this.drawPathList.length - 1; i >= 0; i--) {
      if (this.drawPathList[i].hitTest(x, y)) {
        return i;
      }
    }
    return -1;
  }

  serializeAll(): string {
    let items: DrawPathData[] = [];
    for (let i = 0; i < this.drawPathList.length; i++) {
      items.push(this.drawPathList[i].toJSON());
    }
    return JSON.stringify(items);
  }

  deserializeAll(json: string): void {
    this.clear();
    let rawItems = JSON.parse(json) as Array<Record<string, string | number | boolean | object>>;
    for (let i = 0; i < rawItems.length; i++) {
      let raw = rawItems[i];
      let type = raw['type'] as string;
      let data = new DrawPathData();
      let p = raw['paint'] as Record<string, string | number | boolean | object>;
      data.paint.lineWidth = p['lineWidth'] as number;
      data.paint.strokeStyle = p['strokeStyle'] as string;
      data.paint.globalAlpha = p['globalAlpha'] as number;
      data.paint.isEraser = (p['isEraser'] as boolean) ?? false;
      data.offsetX = raw['offsetX'] as number;
      data.offsetY = raw['offsetY'] as number;
      data.rotation = raw['rotation'] as number;
      if (type === 'shapedraw') {
        data.type = 'shapedraw';
        data.shapeType = raw['shapeType'] as string;
        data.startX = raw['startX'] as number;
        data.startY = raw['startY'] as number;
        data.endX = raw['endX'] as number;
        data.endY = raw['endY'] as number;
        this.add(ShapeDraw.fromJSON(data));
      } else if (type === 'textdraw') {
        data.type = 'textdraw';
        data.text = raw['text'] as string;
        data.x = raw['x'] as number;
        data.y = raw['y'] as number;
        data.fontSize = raw['fontSize'] as number;
        data.fontWeight = raw['fontWeight'] as number;
        data.fontStyle = raw['fontStyle'] as number;
        this.add(TextDraw.fromJSON(data));
      } else {
        data.type = 'drawpath';
        data.isFountainPen = raw['isFountainPen'] as boolean;
        let ptsArr = raw['touchPoints'] as Array<Record<string, string | number | boolean | object>>;
        for (let j = 0; j < ptsArr.length; j++) {
          let pt = ptsArr[j];
          let tpd = new TouchPointData();
          tpd.x = pt['x'] as number;
          tpd.y = pt['y'] as number;
          data.touchPoints.push(tpd);
        }
        let fpArr = raw['fountainPenPoints'] as Array<Record<string, string | number | boolean | object>>;
        for (let j = 0; j < fpArr.length; j++) {
          let fpd = new FountainPenPointData();
          let fp = fpArr[j];
          fpd.x = fp['x'] as number;
          fpd.y = fp['y'] as number;
          fpd.velocity = fp['velocity'] as number;
          data.fountainPenPoints.push(fpd);
        }
        this.add(DrawPath.fromJSON(data));
      }
    }
  }
}
