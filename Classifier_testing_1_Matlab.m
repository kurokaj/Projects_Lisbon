% Data set 1

% Small project for the school while doing my exchange in Lisbon.

% The data sets were provided by the university

% The purpose of this project was to evaluate different classifiers on two datasets with real data and try
% to obtain, for each dataset, the best possible performance.

% Comment the other one, when testing the scripts.

%% 1.1. Naive Bayesian Classifier

%We are splitting the data so that 80% training and 20% validating 
model = fitcnb(Xtrain(1:74,:),Ytrain(1:74,:),'DistributionNames','kernel', 'Kernel','triangle' );
labelvali = predict(model, Xtrain(74:end,:));

%calvulate the number of false classifications in validation
error_v = 0;
for i = 1:size(Ytrain(74:end,:))
   if(labelvali(i) ~= Ytrain(73+i)) 
       error_v = error_v + 1;
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

% Calvulate the number of Loss (Accuracy)
L = loss(model,Xtest,Ytest);

% Calculate the F-measure value (Sensitivity)
p_results=0;
all_p_results=0;
relevant_s = 0;

for j = 1:size(Ytest)
    if label(j) == 1 && label(j) == Ytest(j)
        p_results = p_results + 1;
    end
    if label(j) == 1
        all_p_results = all_p_results + 1;
    end
    if Ytest(j) == 1
        relevant_s = relevant_s + 1;
    end
end
p = p_results / all_p_results;
r = p_results / relevant_s;

F1 = 2* (p*r)/(p+r);

%% 1.2. Support Vector Machine

%We are splitting the data so that 80% training and 20% validating 
model = fitcsvm(Xtrain(1:74,:),Ytrain(1:74,:),'KernelFunction','polynomial','BoxConstraint',100,'KernelScale',5);
labelvali = predict(model, Xtrain(74:end,:));

%calvulate the number of false classifications in validation
error_v = 0;
for i = 1:size(Ytrain(74:end,:))
   if(labelvali(i) ~= Ytrain(73+i)) 
       error_v = error_v + 1;
   end
end

% Use test set to calculate the errors after training
label = predict(model, Xtest);

%calvulate the number of false classifications in validation
error = 0;
for i = 1:size(Ytest)
   if(label(i) ~= Ytest(i)) 
       error = error + 1;
   end
end

%Calvulate the number of Loss (Accuracy)
L = loss(model,Xtest,Ytest);

% Calculate the F-measure value (Sensitivity)
p_results=0;
all_p_results=0;
relevant_s = 0;

for j = 1:size(Ytest)
    if label(j) == 1 && label(j) == Ytest(j)
        p_results = p_results + 1;
    end
    if label(j) == 1
        all_p_results = all_p_results + 1;
    end
    if Ytest(j) == 1
        relevant_s = relevant_s + 1;
    end
end
p = p_results / all_p_results;
r = p_results / relevant_s;

F1 = 2* (p*r)/(p+r);

