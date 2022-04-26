function sleep_performance(pre_post, y_pred)
    pred_corr = sum(y_pred);
    pred_total = length(y_pred);
    pred_perc = pred_corr / pred_total * 100
    println(pre_post, ": ", pred_corr, "/", pred_total, "(", pred_perc, "%) predicted as correct.")
end

function generate_confusion_matrix(y_test, y_pred_test)
    cf = confusion_matrix(y_test, y_pred_test, normalize="true")

    figure()
    disp = ConfusionMatrixDisplay(confusion_matrix=cf, display_labels=simple_logistic.classes_)
    disp.plot()
    gcf()
end