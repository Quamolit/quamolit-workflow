
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |quamolit/ |pointed-prompt/ |touch-control/
    :version |0.0.1
  :entries $ {}
  :files $ {}
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          quamolit.util.string :refer $ hsl
          quamolit.alias :refer $ defcomp group >> line
          quamolit.render.element :refer $ translate button
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (store)
            let
                states $ :states store
                state $ either (:data states)
                  {} $ :tab :portal
                cursor $ []
                tab $ :tab state
              group ({})
                line $ {} (:x0 0) (:y0 0) (:x1 40) (:y1 40)
                  :stroke-style $ hsl 0 0 80
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |task $ quote
          def task $ {} (:text |) (:id nil) (:done? false)
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require (app.schema :as schema)
          quamolit.cursor :refer $ update-states gc-states
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data tick) (; js/console.log "|store update:" op op-data tick)
            case-default op
              do (js/console.log "\"unknown op" op) store
              :states $ update-states store op-data
              :gc-states $ gc-states store op-data
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require
          app.comp.container :refer $ comp-container
          quamolit.core :refer $ render-page configure-canvas setup-events on-control-event
          quamolit.config :refer $ dev?
          quamolit.util.time :refer $ get-tick
          app.updater :refer $ updater
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
          touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
      :defs $ {}
        |main! $ quote
          defn main! ()
            if dev? $ load-console-formatter!
            let
                target $ js/document.querySelector |#app
              configure-canvas target
              setup-events target dispatch!
              render-loop!
              render-control!
              start-control-loop! 8 on-control-event
        |*store $ quote
          defatom *store $ {}
            :states $ {}
        |dispatch! $ quote
          defn dispatch! (op op-data)
            if (list? op)
              recur :states $ [] op op-data
              do (; println "\"dispatch" op op-data) (; js/console.log @*store)
                let
                    new-tick $ get-tick
                    new-store $ updater @*store op op-data new-tick
                  reset! *store new-store
        |*render-loop $ quote (defatom *render-loop nil)
        |render-loop! $ quote
          defn render-loop! (? t)
            let
                target $ js/document.querySelector |#app
              ; js/console.log "\"store" @*store
              render-page (comp-container @*store) target dispatch!
              reset! *render-loop $ js/setTimeout
                fn () $ reset! *raq-loop (js/requestAnimationFrame render-loop!)
                , 20
        |*raq-loop $ quote (defatom *raq-loop nil)
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (js/clearTimeout @*render-loop) (js/cancelAnimationFrame @*raq-loop) (render-loop!) (replace-control-loop! 8 on-control-event) (hud! "\"ok~" "\"Ok")
            hud! "\"error" build-errors
