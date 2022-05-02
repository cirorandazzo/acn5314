using DataFrames
using CSV
using ScikitLearn
using PyPlot
include("training_functions.jl")

@sk_import model_selection: train_test_split;
    
# Models
using ScikitLearn.GridSearch: GridSearchCV
@sk_import linear_model: LogisticRegression;
@sk_import neural_network: MLPClassifier;

# Metrics
@sk_import metrics: accuracy_score;

@sk_import metrics: confusion_matrix;
@sk_import metrics: ConfusionMatrixDisplay;

@sk_import metrics: classification_report;

# Data paths
beh_path = joinpath(pwd(), "recoding/recoded_data/SVD/201222_beh_svd.csv");
pre_path = joinpath(pwd(), "recoding/recoded_data/SVD/201222_pre_svd.csv");
post_path = joinpath(pwd(), "recoding/recoded_data/SVD/201222_post_svd.csv");

# Load data
beh = CSV.read(beh_path, DataFrame)
X_pre = Array(CSV.read(pre_path, DataFrame))
X_post = Array(CSV.read(post_path, DataFrame))

# Split training data (behavior session)
X_beh = Array(beh[!,Not([:correct])])
y_beh = Array(beh[!,:correct])

X_train, X_test, y_train, y_test = train_test_split(X_beh, y_beh, test_size=0.1)


## BASELINE: SIMPLE LOGISTIC REGRESSION ##
# --- train
simple_logistic = LogisticRegression(max_iter=100000000);

fit!(simple_logistic, X_train, y_train)

# --- check accuracy
y_pred_train_log = predict(simple_logistic, X_train);
y_pred_test_log = predict(simple_logistic, X_test);

y_pred_pre_log = predict(simple_logistic, X_pre);
y_pred_post_log = predict(simple_logistic, X_post);

println("---Simple Logistic---")
println("Train accuracy: ", accuracy_score(y_train, y_pred_train_log))
println("Test accuracy: ", accuracy_score(y_test, y_pred_test_log))

println("--Sleep Performance--")
sleep_performance("Pre", y_pred_pre_log)
sleep_performance("Post", y_pred_post_log)
# It is still predicting everything as correct... I think we are having an issue where our "correct" patterns are still occuring during "incorrect" bins, possibly due to lack of temporal specificity (ie, the "wrong" trials occur in between "right" trials.)

generate_confusion_matrix(y_test, y_pred_test_log)

## BASELINE: SHALLOW NEURAL NET ##
# --- train
shallow_neural_net = MLPClassifier(hidden_layer_sizes=(5))

fit!(shallow_neural_net, X_train, y_train)

# --- check accuracy
y_pred_train_snn = predict(shallow_neural_net, X_train)
y_pred_test_snn = predict(shallow_neural_net, X_test)

y_pred_pre_snn = predict(shallow_neural_net, X_pre)
y_pred_post_snn = predict(shallow_neural_net, X_post)

println("---SNN---")
println("Train accuracy: ", accuracy_score(y_train, y_pred_train_snn))
println("Test accuracy: ", accuracy_score(y_test, y_pred_test_snn))

println("--Sleep Performance--")
sleep_performance("Pre", y_pred_pre_snn)
sleep_performance("Post", y_pred_post_snn)

generate_confusion_matrix(y_test, y_pred_test_snn)

## Logistic: 3-Fold Cross Validation ##
gridsearch_logistic = GridSearchCV(LogisticRegression(),
Dict(:solver => ["newton-cg", "lbfgs", "liblinear"], :C => [0.01, 0.1, 0.5, 0.9], :max_iter => [10000]));

# --- train
fit!(gridsearch_logistic, X_train, y_train)

gridsearch_logistic_results = DataFrame(gridsearch_logistic.grid_scores_);
hcat(DataFrame(gridsearch_logistic_results.parameters),
gridsearch_logistic_results)[!,Not(:parameters)]

best_log_model = gridsearch_logistic.best_estimator_

y_pred_train_best_log = predict(best_log_model, X_train);
print(classification_report(y_pred_train_best_log, y_train))

y_pred_test_best_log = predict(best_log_model, X_test)
print(classification_report(y_pred_test_best_log, y_test))

generate_confusion_matrix(y_test, y_pred_test_best_log)


## Shallow Neural Net: 3-Fold Cross Validation ##
gridsearch_neuralnet = GridSearchCV(MLPClassifier(), Dict(:solver => ["sgd", "lbfgs", "adam"], :hidden_layer_sizes => [(2), (20), (1,5,10), (10,10), (10,20,10)]))
fit!(gridsearch_neuralnet, X_train, y_train)
gridsearch_neuralnet_results = DataFrame(gridsearch_neuralnet.grid_scores_);
hcat(DataFrame(gridsearch_neuralnet_results.parameters),
gridsearch_neuralnet_results)[!,Not(:parameters)]

best_neuralnetwork_model = gridsearch_neuralnet.best_estimator_

Y_pred_train_neural = predict(best_neuralnetwork_model, X_train)
print(classification_report(Y_pred_train_neural, Y_train))

Y_pred_test_neural = predict(best_neuralnetwork_model, X_test)
print(classification_report(Y_pred_test_neural, Y_test))