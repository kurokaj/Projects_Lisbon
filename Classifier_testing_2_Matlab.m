% Data set 2

% Small project for the school while doing my exchange in Lisbon.

% The data sets were provided by the university

% The purpose of this project was to evaluate different classifiers on two datasets with real data and try
% to obtain, for each dataset, the best possible performance.

% Comment the other one, when testing the scripts.

%% 2.1. Support Vector Machine

% The data is divided so that 10% is used in validation and 90% in training
model = fitcsvm(Xtrain(92:end,:),Ytrain(92:end,:),'KernelFunction','RBF','BoxConstraint',10^2,'KernelScale',100);
Xvalidation=Xtrain(1:93,:);

label = predict(model, Xvalidation);

%calvulate the number of false classifications in validation
v_error = 0;
for i = 1:size(Ytrain(1:93,:))
   if(label(i) ~= Ytrain(i)) 
       v_error = v_error +1;
   end
end

% Use test set to calculate the errors after training
label = predict(model, Xtest);

% calvulate the number of false classifications with the test set 
error = 0;
for i = 1:size(Ytest)
   if(label(i) ~= Ytest(i)) 
       error = error +1;
   end
end

%Calvulate the number of Loss (Accuracy)
L = loss(model,Xtrain(1:93,:),Ytrain(1:93,:));

% Calculate the F-measure value (Sensitivity)
p_results=0;
all_p_results=0;
relevant_s = 0;

for j = 1:size(Ytrain(1:93,:))
    if label(j) == 1 && label(j) == Ytrain(j)
        p_results = p_results + 1;
    end
    if label(j) == 1
        all_p_results = all_p_results + 1;
    end
    if Ytrain(j) == 1
        relevant_s = relevant_s + 1;
    end
end
p = p_results / all_p_results;
r = p_results / relevant_s;

F1 = 2* (p*r)/(p+r);


%% 2.2 DECISION TREE

% The data is divided so that 10% is used in validation and 90% in training
tree = fitrtree(Xtrain(92:end,:),Ytrain(92:end,:));
prediction = predict(tree,Xtrain(1:92,:));

%calvulate the number of false classifications in validation set
v_error = 0;
for i = 1:size(Ytrain(1:92,:))
   if(prediction(i) ~= Ytrain(i)) 
       v_error = v_error +1;
   end
end

% Use test set to calculate the errors after training
label = predict(tree, Xtest);

% calvulate the number of false classifications with the test set 
error = 0;
for i = 1:size(Ytest)
   if(label(i) ~= Ytest(i)) 
       error = error +1;
   end
end


%Calvulate the number of Loss (Accuracy)
L = loss(tree,Xtest,Ytest);

% Calculate the F-measure value (Sensitivity)
p_results=0;
all_p_results=0;
relevant_s = 0;

for j = 1:size(Ytrain(1:92,:))
    if prediction(j) == 1 && prediction(j) == Ytrain(j)
        p_results = p_results + 1;
    end
    if prediction(j) == 1
        all_p_results = all_p_results + 1;
    end
    if Ytrain(j) == 1
        relevant_s = relevant_s + 1;
    end
end
p = p_results / all_p_results;
r = p_results / relevant_s;

F1 = 2* (p*r)/(p+r);
    
 
