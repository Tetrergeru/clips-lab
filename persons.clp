(deftemplate ioproxy		; шаблон факта-посредника для обмена информацией с GUI
	(slot fact-id)		; теоретически тут id факта для изменения
	(multislot answers)	; возможные ответы
	(multislot messages)	; исходящие сообщения
	(slot reaction)		; возможные ответы пользователя
	(slot value)		; выбор пользователя
	(slot restore)		; забыл зачем это поле
)

(deffacts proxy-fact
	(ioproxy
		(fact-id 0112)	; это поле пока что не задействовано
		(value none)	; значение пустое
		(messages)	; мультислот messages изначально пуст
	)
)

(defrule clear-messages
	(declare (salience 90))
	?clear-msg-flg <- (clearmessage)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages))
	(retract ?clear-msg-flg)
)

(defrule set-output-and-halt
	(declare (salience 99))
	?current-message <- (sendmessagehalt ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule append-output-and-halt
	(declare (salience 99))
	?current-message <- (appendmessagehalt $?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages $?msg-list $?new-msg))
	(retract ?current-message)
	(halt)
)

(defrule set-output-and-proceed
	(declare (salience 99))
	?current-message <- (sendmessage ?new-msg)
	?proxy <- (ioproxy)
	=>
	(modify ?proxy (messages ?new-msg))
	(retract ?current-message)
)

(defrule append-output-and-proceed
	(declare (salience 99))
	?current-message <- (appendmessage ?new-msg)
	?proxy <- (ioproxy (messages $?msg-list))
	=>
	(modify ?proxy (messages $?msg-list ?new-msg))
	(retract ?current-message)
)

;==================================================================================

(deftemplate element
	(slot formula)
	(slot mass)
)

(defrule greeting
	(declare (salience 100))
	=>
	(assert (appendmessagehalt "Колба пуста. Добавьте что-нибудь."))
)

(defrule Электричество_ДигидрогенаМонооксид_Электролиз
   (declare (salience 40))
   (element (formula Электричество) (mass ?m1))
   (element (formula ДигидрогенаМонооксид) (mass ?m2))
   =>
   (assert (element (formula Электролиз) (mass (* (+ ?m1 ?m2) 0.5) )))
   (assert (appendmessagehalt (str-cat "Электричество (" ?m1 "т.) + H2O (" ?m2 "т.) -(0.5)> e " (* (+ ?m1 ?m2) 0.5) )))
)


;(defrule Киноварь_СульфидРтути
;   (declare (salience 40))
;   (element (formula Киноварь))
;   =>
;   (assert (element (formula СульфидРтути)))
;   (assert (appendmessagehalt "Киноварь -> HgS"))
;)
;
;(defrule ЩавелеваяКислота_ЩавелеваяКислота
;   (declare (salience 40))
;   (element (formula ЩавелеваяКислота))
;   =>
;   (assert (element (formula ЩавелеваяКислота)))
;   (assert (appendmessagehalt "ЩавелеваяКислота -> H2C2O4"))
;)
;
;
;(defrule Песок_ОксидКремния
;   (declare (salience 40))
;   (element (formula Песок))
;   =>
;   (assert (element (formula ОксидКремния)))
;   (assert (appendmessagehalt "Песок -> SiO2"))
;)
;
;
;(defrule Известняк_КарбонатКальция
;   (declare (salience 40))
;   (element (formula Известняк))
;   =>
;   (assert (element (formula КарбонатКальция)))
;   (assert (appendmessagehalt "Известняк -> CaCO3"))
;)
;
;
;(defrule Вода_ДигидрогенаМонооксид
;   (declare (salience 40))
;   (element (formula Вода))
;   =>
;   (assert (element (formula ДигидрогенаМонооксид)))
;   (assert (appendmessagehalt "Вода -> H2O"))
;)
;