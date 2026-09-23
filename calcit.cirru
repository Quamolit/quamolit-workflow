
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.bootstrap/main!) (:mode :js) (:reload-fn 'app.bootstrap/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |pointed-prompt/ |touch-control/ |js-ffi/ |quamolit/
      :type-slots $ {}
  :files $ {}
    'app.bootstrap $ %{} 'FileEntry
      :defs $ {}
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.bootstrap
    'app.comp.container $ %{} 'FileEntry
      :defs $ {} $ 'comp-container
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                states $ :states store
                state $ either (:data states)
                  {} $ :tab :portal
                cursor $ []
                tab $ :tab state
              group ({})
                line $ {} (:x0 0) (:y0 0) (:x1 40) (:y1 40)
                  :stroke-style $ hsl 0 0 80
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            quamolit.util.string :refer $ hsl
            quamolit.alias :refer $ defcomp group >> line
            quamolit.render.element :refer $ translate button
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*raq-loop $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *raq-loop nil
          :examples $ []
          :schema $ :: 'Dynamic
        '*render-loop $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *render-loop nil
          :examples $ []
          :schema $ :: 'Dynamic
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *store
            {} $ :states $ {}
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op op-data)
            if (list? op)
              recur :states $ [] op op-data
              do (; println |dispatch op op-data) (; js/console.log @*store)
                let
                    new-tick $ get-tick
                    new-store $ updater @*store op op-data new-tick
                  reset! *store new-store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if dev? $ load-console-formatter!
            let
                target $ js/document.querySelector |#app
              configure-canvas target
              setup-events target dispatch!
              render-loop! 0
              render-control!
              start-control-loop! 8 on-control-event
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (js/clearTimeout @*render-loop) (js/cancelAnimationFrame @*raq-loop) (render-loop! 0) (replace-control-loop! 8 on-control-event) (hud! |ok~ |Ok)
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ []
            :features $ #{} :js-ffi
        'render-loop! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-loop! (t)
            let
                target $ js/document.querySelector |#app
              ; js/console.log |store @*store
              render-page (comp-container @*store) target dispatch!
              reset! *render-loop $ js/setTimeout
                fn () $ reset! *raq-loop $ js/requestAnimationFrame render-loop!
                , 20
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            app.comp.container :refer $ comp-container
            quamolit.core :refer $ render-page configure-canvas setup-events on-control-event
            quamolit.config :refer $ dev?
            quamolit.util.time :refer $ get-tick
            app.updater :refer $ updater
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'task
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def task
            {} (:text |) (:id nil) (:done? false)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-data tick) (; js/console.log "|store update:" op op-data tick)
            case-default op
              do (js/console.log "|unknown op" op) store
              :states $ update-states store op-data
              :gc-states $ gc-states store op-data
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Dynamic 'Dynamic 'Dynamic 'Dynamic
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require (app.schema :as schema)
            quamolit.cursor :refer $ update-states gc-states
