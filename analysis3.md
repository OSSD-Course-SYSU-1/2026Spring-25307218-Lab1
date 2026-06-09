# Custom Canvas 自定义画布应用 - 功能详细介绍

---

## 0. 工程目录

```
custom-canvas-master/
├── AppScope/                                    # 应用全局作用域
│   ├── app.json5                                #   应用全局配置（包名、版本号、图标、标签）
│   └── resources/base/
│       ├── element/string.json                  #   应用级字符串资源（app_name）
│       └── media/app_icon.png                   #   应用图标
│
├── entry/                                       # 主模块（HAP 包）
│   ├── build-profile.json5                      #   模块构建配置（API 类型、混淆规则）
│   ├── oh-package.json5                         #   模块包依赖信息
│   ├── obfuscation-rules.txt                    #   代码混淆规则
│   └── src/main/
│       ├── module.json5                         #   模块配置（Ability声明、deviceTypes:phone/tablet/2in1、continuable:true）
│       │
│       ├── ets/                                 # ===== ArkTS 源码 =====
│       │   ├── entryability/
│       │   │   └── EntryAbility.ets             #     应用入口Ability（onContinue/onCreate/onNewWant + 窗口尺寸监听）
│       │   │
│       │   ├── common/
│       │   │   ├── CommonConstants.ets          #     公共常量类 + COLOR_GRAY_ROW + COLOR_GRID + hslToHex/generateGrayRow/generateColorGrid
│       │   │   ├── ScreenInfo.ets               #     屏幕信息工具类
│       │   │   └── BreakpointSystem.ets         #     断点系统（SM/MD/LG + 折叠缩放）
│       │   │
│       │   ├── pages/
│       │   │   └── Index.ets                    #     主页面（双层Canvas + 底部工具栏 + 手势处理 + 作图工具面板 + 流转 + 分布式 + 断点 + 键盘快捷键）
│       │   │
│       │   ├── view/
│       │   │   ├── myPaintSheet.ets             #     半模态设置面板（笔刷/网格选色/RGB滑块/不透明度/粗细）
│       │   │   └── textInputSheet.ets           #     文字输入面板（字号列表/粗体/斜体/颜色选择）
│       │   │
│       │   └── viewmodel/                       #     视图模型层（MVVM）
│       │       ├── DrawInvoker.ets              #       绘制命令管理器（命令模式：撤销/重做/执行 + 序列化toJSON/fromJSON）
│       │       ├── IBrush.ets                   #       笔刷接口IBrush + NormalBrush + FountainPenBrush
│       │       ├── IDraw.ets                    #       绘制接口IDraw + DrawPath + ShapeDraw + TextDraw + DrawPathData + TouchPointData
│       │       ├── Paint.ets                    #       画笔属性类（线宽、颜色、透明度）+ PaintData
│       │       ├── DistributedCanvas.ets        #       分布式数据对象 + 增量变更同步
│       │       ├── RemoteCursorManager.ets      #       多用户光标管理
│       │       ├── ConflictResolver.ets         #       OT冲突解决
│       │       ├── VersionHistory.ets            #       版本历史快照
│       │       └── DistributedFileManager.ets   #       文件保存/加载/SVG导出
│       │
│       └── resources/                           # ===== 应用资源 =====
│           ├── base/                            #   基础资源（默认语言 + 所有断点资源名定义）
│           │   ├── element/
│           │   │   ├── color.json               #     颜色资源（主题色、笔刷背景色、渐变色等）
│           │   │   ├── float.json               #     尺寸资源（所有$r引用的资源名 + 默认值）
│           │   │   └── string.json              #     字符串资源（按钮标签、面板标题、syncing/synced/version/save等）
│           │   ├── media/                       #     图标资源（SVG）
│           │   │   ├── paintbrush.svg           #       画笔图标（普通态）
│           │   │   ├── paintbrush_active.svg    #       画笔图标（激活态）
│           │   │   ├── Ballpoint.svg            #       圆珠笔图标（普通态）
│           │   │   ├── Ballpoint_active.svg     #       圆珠笔图标（激活态）
│           │   │   ├── marker.svg               #       马克笔图标（普通态）
│           │   │   ├── marker_active.svg        #       马克笔图标（激活态）
│           │   │   ├── fountain.svg             #       钢笔图标（普通态）
│           │   │   ├── fountain_active.svg      #       钢笔图标（激活态）
│           │   │   ├── rubbers.svg              #       橡皮擦图标（普通态）
│           │   │   ├── rubbers_active.svg       #       橡皮擦图标（激活态）
│           │   │   ├── recall.svg               #       撤回图标（普通态）
│           │   │   ├── recall_active.svg        #       撤回图标（激活态）
│           │   │   ├── redo.svg                 #       重做图标（普通态）
│           │   │   ├── redo_active.svg          #       重做图标（激活态）
│           │   │   ├── clear.svg                #       清空图标（普通态）
│           │   │   ├── clear_active.svg         #       清空图标（激活态）
│           │   │   ├── cube/cylinder/cone/pyramid/sphere.svg  # 3D形体图标
│           │   │   ├── foreground.svg           #       应用图标前景（钢笔+调色板）
│           │   │   ├── background.svg           #       应用图标背景（蓝色渐变圆角矩形）
│           │   │   ├── startIcon.svg            #       启动图标（完整合成）
│           │   │   └── layered_image.json       #       分层图标配置
│           │   └── profile/
│           │       ├── main_pages.json          #     页面路由配置（注册 pages/Index）
│           │       └── backup_config.json       #     备份配置
│           │
│           ├── sm/element/float.json            #   手机断点尺寸资源（48vp/80vp/22fp/12fp等）
│           ├── md/element/float.json            #   平板断点尺寸资源（56vp/96vp/26fp/14fp等）
│           ├── lg/element/float.json            #   桌面断点尺寸资源（64vp/112vp/30fp/16fp等）
│           ├── zh_CN/element/string.json        #   中文字符串资源
│           └── en_US/element/string.json        #   英文字符串资源
│
├── PLAN.md                                      # 主演进计划
├── plan1.md                                     # 多端部署计划（Phase 1-4）
├── plan2.md                                     # 跨设备投送计划（Phase 1-4）
├── build-profile.json5                          # 项目级构建配置（SDK 版本、运行时 OS、构建模式）
├── oh-package.json5                             # 项目级包信息
├── hvigorfile.ts                                # Hvigor 构建脚本
└── LICENSE                                      # Apache License 2.0
```

---

## 1. 自由绘画

### 1.1 触摸绘制

应用的核心功能是在 Canvas 画布上通过手指触摸进行自由绘画。采用**双层 Canvas** 架构：

- **底层 Canvas（offContext）**：白色背景，显示所有已提交路径的快照，仅在路径提交/undo/redo/clear 时重绘
- **顶层 Canvas（context）**：透明背景，仅绘制当前正在书写的笔画预览

**触摸按下（TouchType.Down）**：
- 创建新的 `DrawPath`，包含当前画笔属性和空的 `Path2D` 路径对象
- 调用笔刷的 `down()` 方法，在路径上执行 `moveTo(x, y)`

**触摸移动（TouchType.Move）**：
- 调用笔刷的 `move()` 方法，在路径上添加线段
- 仅清空顶层 Canvas 并重绘当前笔画（`clearTopCanvas()` + `mPath.draw()`），不遍历历史路径
- 钢笔模式下同步速度点数据实现实时变宽预览

**触摸抬起（TouchType.Up）**：
- 将路径添加到 `DrawInvoker` 历史列表
- **增量渲染**：仅将新路径追加画到底层离屏 Canvas（`appendToOffCanvas()`），不清空不重绘历史
- 清空顶层 Canvas，笔画显示在底层上
- 重置 mPath 防止 TouchUp 重新提交

### 1.2 增量渲染优化

- **TouchUp**：只把新路径追加到离屏 Canvas（O(1)），不重绘全部历史
- **undo/redo/clear**：全量重绘离屏 Canvas（`refreshOffCanvas()`），这些操作频率低
- 避免了钢笔路径多时每帧重绘全部历史导致的卡顿

---

## 2. 画笔模式

### 2.1 画笔工具

点击底部工具栏的"画笔"按钮进入画笔模式，弹出半模态设置面板。

### 2.2 橡皮擦工具

点击"橡皮擦"按钮，画笔属性重置为白色、粗细10、透明度1，用白色线条覆盖原有内容。选中状态下显示蓝色高亮边框。

### 2.3 模式互斥

画笔和橡皮擦通过 `isPaint` 状态变量互斥控制。

---

## 3. 笔刷选择

在半模态设置面板的"笔刷"区域，提供 3 种笔刷类型：

### 3.1 圆珠笔

- 默认选中的笔刷，使用 `NormalBrush`（`lineTo` 直线连接）
- 不透明度固定为 100%

### 3.2 马克笔

- 半透明笔刷，使用 `NormalBrush`，模拟马克笔荧光效果
- 不透明度默认为 50%，可自由调节

### 3.3 钢笔

- 模拟钢笔的书写效果，使用 `FountainPenBrush`，带有笔锋粗细变化
- 基于速度感知的变宽渲染：慢速→粗笔（1.5x），快速→细笔（0.4x）
- 使用二次贝塞尔曲线平滑笔触，首尾渐细（taper）
- 不透明度默认为 100%，可自由调节
- **已修复双重偏移bug**：`moveBy()` 同时修改fountainPenPoints坐标和offsetX/Y导致双重偏移

---

## 4. 钢笔（FountainPenBrush）

### 4.1 速度追踪

- 每次 `move()` 计算当前速度（距离/时间），指数移动平均平滑（SMOOTH_FACTOR=0.3）
- 每个触摸点记录坐标 + 平滑速度到 `FountainPenPoint[]`

### 4.2 变宽渲染

`DrawPath.drawFountainPen()` 逐段渲染：
1. 根据速度计算每点宽度：`widthFactor = 1.5 - normalizedVelocity * 1.1`
2. 3点移动平均平滑宽度（2次）
3. 首尾渐细（taper），前4点和后4点线性递减
4. 逐段 `lineTo` + `stroke()`，相邻段取平均宽度过渡

---

## 5. 颜色选择

### 5.1 双模式切换

颜色选择支持两种模式，通过点击"颜色"标题旁的蓝色文字切换：
- **网格选色**（colorMode=0）：10列灰度条 + 9×10色彩网格
- **RGB滑块**（colorMode=1）：R/G/B三色滑块（0-255）

两种模式通过 `syncRgbFromColor()` / `updateColorFromRgb()` 双向同步，切换时自动保持当前颜色一致。

### 5.2 网格选色

**灰度条**（`COLOR_GRAY_ROW`）：10个灰度色块，从黑到白均匀分布。

**色彩网格**（`COLOR_GRID`）：9行×10列，由 `generateColorGrid()` 生成：
- 横向：色相从0°到360°均匀分布（红→橙→黄→绿→青→蓝→紫→红）
- 纵向：明度从亮到暗（90%→10%），通过HSL色彩空间转HEX
- 选中色块显示白色边框高亮

### 5.3 RGB 三色滑块

在RGB模式下提供 R/G/B 三个滑块（0-255）：
- 红色滑块：标识色 `#E90808`
- 绿色滑块：标识色 `#63B959`
- 蓝色滑块：标识色 `#0A59F7`
- 拖动任意滑块实时合成 HEX 颜色并更新当前色和预览
- 在网格选色中点击色块时自动同步 RGB 滑块值
- 每个滑块右侧显示当前数值

### 5.4 当前颜色预览

颜色栏下方显示"当前颜色"文字 + 实时跟随的色块圆点。

---

## 6. 不透明度调节

- 使用 `Slider` 组件（`InSet` 样式），范围 0~100
- 所有笔刷和作图工具模式下均可调整不透明度
- 右侧显示百分比数值

---

## 7. 粗细调节

- 使用 `Slider` 组件，范围 3~21，步长 1
- 右侧显示当前粗细数值
- 拖动滑块即时更新画笔属性

---

## 8. 作图工具

### 8.1 独立工具栏

作图工具从画笔面板中独立出来，位于底部工具栏的第二个按钮。点击弹出独立半模态面板选择工具。

### 8.2 支持的形状

| 工具 | 图标 | 绘制方式 |
|------|------|----------|
| 直尺 | `/`（斜线） | 两点之间画直线 |
| 圆 | `○` | 以按下点为圆心，拖动距离为半径画圆 |
| 矩形 | `□` | 以按下点和抬起点为对角顶点画矩形 |
| 椭圆 | `⬭` | 以对角线确定外接矩形画椭圆 |
| 三角形 | `△` | 以按下点为顶点，拖动确定底边画等腰三角形 |
| 菱形 | `◇` | 以中心点+拖动距离画菱形 |
| 星形 | `☆` | 以中心点+拖动距离画五角星 |
| 箭头 | `→` | 两点之间画带箭头的直线 |
| 立方体 | cube.svg | 以中心点+拖动距离画3D立方体 |
| 圆柱 | cylinder.svg | 以中心点+拖动距离画3D圆柱 |
| 圆锥 | cone.svg | 以中心点+拖动距离画3D圆锥 |
| 棱锥 | pyramid.svg | 以中心点+拖动距离画3D棱锥 |
| 球体 | sphere.svg | 以中心点+拖动距离画3D球体 |
| 文字 | `A` | 点击画布放置文字，双击编辑 |

### 8.3 形状绘制流程

1. **Down**：记录起始点坐标
2. **Move**：实时预览形状（清空顶层 Canvas + 绘制当前形状）
3. **Up**：提交 `ShapeDraw` 到历史，增量追加到离屏 Canvas

### 8.4 ShapeDraw 类

`ShapeDraw extends DrawPath`，包含 `shapeType`、`startX/Y`、`endX/Y` 属性，`draw()` 方法根据 `shapeType` 绘制对应形状。

---

## 9. 文字输入与编辑

### 9.1 TextDraw 类

`TextDraw extends DrawPath`，新增属性：
- `textContent`：文字内容
- `textFontSize`：字号（Word pt值，渲染时×2.5转px）
- `textFontWeight`：粗体（FontWeight.Bold/Normal）
- `textFontStyle`：斜体（FontStyle.Italic/Normal）
- `textColor`：文字颜色
- 位置通过 `startX/Y` 确定，`endX/Y` 计算文字边界框

### 9.2 textInputSheet 组件

半模态弹窗，包含：
- **文字输入区**：TextArea组件输入文字内容
- **字号选择器**：垂直滚动列表，包含中文字号（初号/小初/一号~八号）和磅值（5~72pt）
- **粗体/斜体切换**：按钮式切换，选中高亮
- **颜色选择**：灰度条+色彩网格（与画笔面板相同）
- **字号显示**：右侧显示当前选中字号数值

### 9.3 文字交互

- **放置**：选择文字工具后，点击画布放置文字
- **拖拽移动**：触摸已有文字可拖拽移动位置
- **双击编辑**：双击已有文字弹出textInputSheet重新编辑
- **虚线框**：选中文字显示自适应虚线边框

### 9.4 字号单位

- Word字号是pt值，Canvas font用px单位
- 换算系数：`fontSize * 2.5`，效果合适

---

## 10. 撤销/重做

### 10.1 撤销

- 调用 `drawInvoker.undo()`，从路径列表移入重做列表
- 触发离屏 Canvas 全量重绘（`refreshOffCanvas()`）

### 10.2 重做

- 调用 `drawInvoker.redo()`，从重做列表移回路径列表
- 触发离屏 Canvas 全量重绘

### 10.3 状态联动

- 新绘制后清空重做列表，禁用重做按钮
- 撤销/重做按钮通过 `.enabled()` 控制可交互状态

---

## 11. 清空画布

- 调用 `clear()` 方法，清空路径列表和重做列表
- 重置 mPath 防止清空后点击屏幕重现图形
- 触发离屏 Canvas 全量重绘，画布恢复空白
- 禁用撤回和重做按钮
- 清空操作不可撤销

---

## 12. 双指缩放

- Canvas 和上层透明 Column 均绑定 `PinchGesture`
- 缩放期间 `index=1`，透明层拦截触摸事件阻止绘制
- 缩放通过 Canvas 的 `.scale()` 属性实现，视觉缩放不影响坐标
- 缩放过程中清空顶层 Canvas，缩放结束后重绘

---

## 13. 折叠屏适配

- 通过 `display.on('foldStatusChange')` 监听折叠状态
- 使用 `BreakpointSystem.getFoldScaleRatio()` 动态计算缩放比（非硬编码0.5）
- 折叠态/展开态自适应，状态切换后重绘离屏 Canvas

---

## 14. 半模态设置面板

### 14.1 画笔面板

- 点击"画笔"按钮弹出，包含：笔刷选择（3种）、颜色选择（网格/RGB切换+当前预览）、不透明度、粗细
- 面板高度 detents: [650, 750]

### 14.2 作图工具面板

- 点击"作图工具"按钮弹出，包含直尺/圆/矩形/椭圆/三角形/菱形/星形/箭头/3D形体/文字选项
- 选择工具后面板自动关闭
- 再次点击按钮取消作图工具，恢复自由绘画

### 14.3 文字输入面板

- 选择文字工具或双击已有文字时弹出
- 包含：文字输入区、字号滚动列表、粗体/斜体切换、颜色选择

---

## 15. 底部工具栏

### 15.1 布局

- 按钮均匀分布（`SpaceEvenly`），尺寸通过 `$r('app.float.tool_icon_size')` 引用，按断点自适应
- 布局顺序：画笔 → 作图工具 → 橡皮擦 → 撤回 → 重做 → 清空

### 15.2 按钮结构

每个按钮采用 `Stack` 堆叠布局：
1. **显示层**（Column）：图标 + 文字标签，根据状态切换
2. **交互层**（Button）：透明背景的全尺寸按钮

---

## 16. 双层 Canvas 渲染架构

### 16.1 架构说明

```
┌─────────────────────────────────┐
│  顶层 Canvas (context)          │  ← 透明背景，仅绘制当前笔画/形状预览
│  - Move: clearTopCanvas() + draw│
│  - Up: appendToOffCanvas() + clear
├─────────────────────────────────┤
│  底层 Canvas (offContext)       │  ← 白色背景，显示所有已提交路径快照
│  - Up: 增量追加新路径            │
│  - Undo/Redo/Clear: 全量重绘    │
└─────────────────────────────────┘
```

### 16.2 性能优势

| 场景 | 传统方式 | 双层Canvas |
|------|----------|------------|
| Move绘制 | clearRect + 遍历全部历史重绘 O(N) | clearTop + draw当前笔画 O(1) |
| TouchUp | 全量重绘 O(N) | 增量追加1条路径 O(1) |
| Undo/Redo | 全量重绘 O(N) | 全量重绘 O(N)，但频率低 |

---

## 17. 画笔属性同步机制

### 17.1 ToggleThicknessColor()

修改任何画笔参数时调用：
1. 创建新 `Paint` 对象
2. 设置线宽、颜色、透明度
3. 根据笔刷类型创建对应实例：钢笔→`FountainPenBrush`，其他→`NormalBrush`

### 17.2 数据流向

```
myPaintSheet (子组件)
  │ @Link: isMarker, isFountainPen, shapeTool, alpha, percent, color, strokeWidth
  │ @Consume: mPaint, mBrush
  │
  ▼
DrawCanvas (主页面)
  │ @State: isDrawing, isPaint, isShow, isShapeShow, ...
  │ @Provide: mPaint, mBrush
  │
  └─ 下次触摸绘制时，使用最新的 mPaint 和 mBrush 创建 DrawPath
```

### 17.3 关键特性

- 画笔属性的修改**不会**影响已绘制的路径：每条 `DrawPath` 在创建时保存了当时的 `Paint` 对象快照
- 同一画布上可以存在不同颜色、粗细、透明度的线条

---

## 18. SVG 矢量图标

### 18.1 图标设计

应用图标采用 SVG 矢量格式，由 `layered_image.json` 配置分层：

- **foreground.svg**：钢笔（金质笔尖 + 深色笔身 + 银色笔夹）+ 调色板（6色圆点）+ 墨滴 + 星光效果
- **background.svg**：蓝色渐变圆角矩形（#EBF5FB → #D6EAF8 → #AED6F1）
- **startIcon.svg**：合成完整启动图标（背景+前景一体）

### 18.2 优势

- 矢量格式，任意缩放不失真
- 图标主题呼应应用定位（画布+绘画工具）
- SVG 优先级高于 PNG，HarmonyOS 自动匹配同名 SVG 文件

---

## 19. 序列化与跨设备流转

### 19.1 序列化（toJSON/fromJSON）

所有绘制对象实现 `toJSON()` 返回 `DrawPathData` 统一数据类：
- `DrawPathData` 包含所有字段（type/paint/pathPoints/shapeType/startX-Y/endX-Y/textContent/textFontSize等）
- 通过 `type` 字段区分路径类型（'draw'/'shape'/'text'）
- ArkTS 严格模式：toJSON 必须返回显式声明的类，不能是 `Record<string, Object>`

### 19.2 流转生命周期

- **module.json5**：声明 `continuable: true`
- **onContinue**：序列化画布数据，校验大小≤100KB，超限返回 `REJECT` 优雅降级
- **onCreate**（恢复）：反序列化 DrawPathData 列表，重建 DrawPath/ShapeDraw/TextDraw
- **onNewWant**：处理流转后新实例启动
- **syncToAppStorage**：流转数据同步到 AppStorage

---

## 20. 分布式实时同步

### 20.1 DistributedCanvas.ets

基于 `@ohos.data.distributedDataObject` 实现多设备实时同步：
- `create(context, source)` 创建分布式数据对象
- 监听增量变更，同步笔画添加/撤销/重做/清空操作
- 同步状态UI：显示 syncing/synced 指示器 + 远程设备数量

### 20.2 RemoteCursorManager.ets

- 管理多用户远程光标位置和设备名
- 每个远程设备显示不同颜色的圆点+设备名标签
- 光标位置实时同步更新

### 20.3 ConflictResolver.ets

- 基于OT（Operational Transformation）算法解决并发编辑冲突
- 当多个设备同时编辑同一区域时自动合并变更

### 20.4 VersionHistory.ets

- 维护画布状态快照历史
- 支持回滚到历史版本

### 20.5 DistributedFileManager.ets

- 文件保存/加载（使用 `@kit.CoreFileKit` 的 openSync/writeSync/readSync/closeSync）
- SVG导出功能
- TextEncoder/TextDecoder 使用 `@kit.ArkTS` 的 `util.TextEncoder`/`util.TextDecoder`

---

## 21. 一次开发多端部署

### 21.1 设备类型声明

`module.json5` 中 `deviceTypes: ["phone", "tablet", "2in1"]`，支持手机/平板/桌面设备。

### 21.2 Canvas自适应

Canvas 尺寸从固定 `CANVAS_WIDTH = 750` 改为 `CommonConstants.ONE_HUNDRED_PERCENT`（100%自适应），适配不同屏幕尺寸。

### 21.3 断点系统

`BreakpointSystem.ets` 提供 SM/MD/LG 三断点：
- **SM**（<600vp）：手机竖屏
- **MD**（600~840vp）：平板/手机横屏
- **LG**（>840vp）：桌面/大屏平板

通过 `@StorageProp('currentBreakpoint')` 驱动组件响应式布局。

### 21.4 资源限定目录

HarmonyOS 支持 `resources/sm/`、`resources/md/`、`resources/lg/` 断点限定目录，同名资源在不同断点下提供不同值。

所有UI硬编码数值已替换为 `$r('app.float.xxx')` 引用：

| 资源名 | SM(手机) | MD(平板) | LG(桌面) | 用途 |
|--------|----------|----------|----------|------|
| tool_icon_size | 48vp | 56vp | 64vp | 工具图标尺寸 |
| tool_btn_width | 80vp | 96vp | 112vp | 工具按钮宽度 |
| tool_sub_icon_size | 24vp | 28vp | 32vp | 3D图标尺寸 |
| tool_icon_font | 22fp | 26fp | 30fp | 图标字号 |
| tool_label_font | 12fp | 14fp | 16fp | 工具标签字号 |
| tool_title_font | 16fp | 18fp | 20fp | 面板标题字号 |
| tool_border_radius | 24vp | 28vp | 32vp | 工具圆角 |
| tool_margin_top | 6vp | 8vp | 10vp | 标签上边距 |
| sync_indicator_size | 8vp | 10vp | 12vp | 同步指示器尺寸 |
| sync_font | 12fp | 14fp | 16fp | 同步文字字号 |
| cursor_size | 12vp | 14vp | 16vp | 远程光标尺寸 |
| color_grid_width | 26vp | 30vp | 34vp | 颜色格子宽 |
| color_grid_height | 20vp | 24vp | 28vp | 颜色格子高 |
| bold_btn_width | 48vp | 56vp | 64vp | 粗体按钮宽 |
| bold_btn_height | 36vp | 42vp | 48vp | 粗体按钮高 |

### 21.5 窗口适配

- `EntryAbility.ets` 监听 `window.on('windowSizeChange')` 事件
- 自由窗口模式下画布和工具栏动态重排

---

## 22. 键盘快捷键

- **Delete/Backspace**（keyCode 8/127）：删除选中图形
- **Escape**（keyCode 27）：取消选择，关闭形状菜单
- 注：Ctrl+Z/Y快捷键因HarmonyOS KeyEvent不提供ctrlKey/shiftKey属性而不可用

---

## 23. 鼠标交互

- `.onMouse()` 监听鼠标事件
- **鼠标后退按钮**（MouseButton.Back）：忽略不处理
- 注：滚轮缩放因HarmonyOS MouseAction不包含Scroll枚举值而不可用，使用双指缩放替代
