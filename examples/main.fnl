;; translate function calls to fennel


(local shapes_ (require :shapes))
(local text_ (require :text))
(local color (require :colors))
(local window (require :window))
(local draw (require :drawing))

(fn set_window []
    (window.title "Fennel test")
    (window.set_width_height 400 400)
)

(fn draw_hello []
    (let [example "hello from Fennel"
         point (shapes_.newpoint 100 200) ;;  point = shapes_.newpoint(100, 200)
         text_size 16
         ]
  (draw.clear_background color.BLACK) ;; draw.clear_background(color.BLACK)
  (text_.draw_text example point text_size color.GREEN)  ;;  text.draw_text(example, pint, text_size, color.GREEN)
  )
  )

;; Return a table containing the functions you want to expose
{: set_window : draw_hello }
