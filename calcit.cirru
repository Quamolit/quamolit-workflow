
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |js-ffi/ |quamolit/
      :type-slots $ {}
  :files $ {} $ 'app.main
    %{} 'FileEntry
      :defs $ {}
        'ChartModel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct ChartModel (:start 'Number) (:revision 'Number) (:alternate? 'Bool)
            :from $ :: 'List 'Number
            :to $ :: 'List 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'Viewport $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Viewport (:width 'Number) (:height 'Number)
          :examples $ []
          :schema $ :: 'StructDef
        'bar-motion $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bar-motion (index model viewport)
            let
                width $ plot-width viewport
              motion/ScalarDescriptor :id (str |bar- index) :version (:revision model) :motion $ motion/ScalarMotion :tween $ motion/ScalarTween :start
                + (:start model) (* index 0.1)
                , :duration 0.5 :from
                  * width $ &list:nth (:from model) index
                  , :to
                    * width $ &list:nth (:to model) index
                    , :easing (motion/Easing :smoothstep)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quamolit.motion/ScalarDescriptor)
            :args $ [] 'Number 'app.main/ChartModel 'app.main/Viewport
        'bar-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bar-node (index model viewport)
            let
                id $ str |bar- index
                width $ plot-width viewport
              scene/SceneNode :id id :key id :parent | :interaction (scene/SceneInteraction :none) :content
                scene/SceneContent :rect $ scene/RectNode :x
                  /
                    - (:width viewport) width
                    , 2
                  , :y
                    +
                      -
                        / (:height viewport) 2
                        , 70
                      * index 52
                    , :width
                      * width $ &list:nth (:from model) index
                      , :height 32 :fill $ motion/ColorRgba :r
                        + 0.2 $ * index 0.2
                        , :g 0.7 :b 0.85 :a 1
                , :bindings $ [] $ scene/ScalarBinding :target (scene/ScalarTarget :width) :motion-id id :version (:revision model)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quamolit.scene-ir/SceneNode)
            :args $ [] 'Number 'app.main/ChartModel 'app.main/Viewport
        'declare $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn declare (props model input resources viewport)
            let
                original $ scene/SceneNode :id |original-line :key |original-line :parent | :bindings ([]) :interaction (scene/SceneInteraction :none) :content $ scene/SceneContent :polyline
                  scene/PolylineNode :points
                    []
                      motion/Vec2 :x
                        -
                          / (:width viewport) 2
                          , 20
                        , :y $ +
                          / (:height viewport) 2
                          , 130
                      motion/Vec2 :x
                        +
                          / (:width viewport) 2
                          , 20
                        , :y $ +
                          / (:height viewport) 2
                          , 170
                    , :width 2 :stroke $ motion/ColorRgba :r 0.8 :g 0.8 :b 0.8 :a 1
              component/ComponentDeclaration :scene
                scene/SceneDocument :nodes $ concat ([] original)
                  map (range 3)
                    fn (index) (bar-node index model viewport)
                , :motions $ map (range 3)
                  fn (index) (bar-motion index model viewport)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quamolit.component-sample/ComponentDeclaration)
            :args $ [] 'Number 'app.main/ChartModel 'Bool 'Bool 'app.main/Viewport
        'draw! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn draw! (context plan width height dpr) (context .set-transform! dpr 0 0 dpr 0 0) (canvas/fill-solid-rect! context 0 0 width height |#111725) (retained/draw-plan! context plan)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'js-ffi.canvas-batches/CanvasContextHost 'quamolit.retained-component/ComponentPlan 'Number 'Number 'Number
            :features $ #{} :js-ffi
        'initial $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn initial ()
            ChartModel :start 0 :revision 0 :alternate? false :from ([] 0 0 0) :to $ [] 0.4 0.7 1
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.main/ChartModel)
            :args $ []
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            assert |invalid-template-start $ = 4 $ count
              :nodes $ :scene $ start (initial) 0 (viewport 1000 700)
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'plot-width $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn plot-width (viewport)
            let
                available $ - (:width viewport) 64
              if (< available 16) 16 $ if (> available 480) 480 available
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ [] 'app.main/Viewport
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'request $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn request (model time viewport)
            component/ComponentRequest :id |starter-chart :time time :props 1 :model model :input false :resources false :viewport viewport :versions $ direct/FrameVersions :component 1 :motion (:revision model) :model (:revision model) :input 0 :resources 0 :viewport $ +
              * 100000 $ :width viewport
              :height viewport
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.main/ChartModel 'Number 'app.main/Viewport
            :return $ :: 'quamolit.component-sample/ComponentRequest 'Number 'app.main/ChartModel 'Bool 'Bool 'app.main/Viewport
        'start $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn start (model time viewport)
            retained/build-component-plan (request model time viewport) declare
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quamolit.retained-component/ComponentPlan)
            :args $ [] 'app.main/ChartModel 'Number 'app.main/Viewport
        'toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn toggle (model time)
            ChartModel :start time :revision
              inc $ :revision model
              , :alternate?
                not $ :alternate? model
                , :from (values-at model time) :to $ if (:alternate? model) ([] 0.4 0.7 1) ([] 1 0.35 0.8)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.main/ChartModel)
            :args $ [] 'app.main/ChartModel 'Number
        'update-plan $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-plan (plan model time viewport)
            retained/update-component-plan plan (request model time viewport) declare
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'quamolit.retained-component/ComponentPlan)
            :args $ [] 'quamolit.retained-component/ComponentPlan 'app.main/ChartModel 'Number 'app.main/Viewport
        'values-at $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn values-at (model time)
            map-indexed (:from model)
              fn (index value)
                ui/tween-at
                  + (:start model) (* index 0.1)
                  , 0.5 value
                    &list:nth (:to model) index
                    , time
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.main/ChartModel 'Number
            :return $ :: 'List 'Number
        'viewport $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn viewport (width height)
            assert |invalid-template-viewport $ and (motion/finite-number? width) (motion/finite-number? height) (> width 0) (> height 0)
            Viewport :width width :height height
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.main/Viewport)
            :args $ [] 'Number 'Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require (quamolit.motion :as motion) (quamolit.ui-motion :as ui) (quamolit.scene-ir :as scene) (quamolit.component-sample :as component) (quamolit.direct-frame :as direct) (quamolit.retained-component :as retained) (js-ffi.canvas-batches :as canvas)
