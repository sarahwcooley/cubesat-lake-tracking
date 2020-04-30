%Organizes validation data, creates and saves tree bagger model

%create_validation_table
load('complete_validation_dataset.mat');
[validation_table,validation_matrix] = create_validation_table(complete_validation_dataset); 


t = validation_table; 
t.Tile = [];
t.Lake_ID = [];
t.Area = [];
validation_v1 = t.Validation;
validation_v2 = t.Validation_Edited;
t.Validation = [];
t.Validation_Edited = [];


%Create a validation classification model using random forests from matlab
%function "TreeBagger"

model = TreeBagger(50,t,validation_v1,'OOBVarImp','On'); %check matlab specifications for "TreeBagger" to change parameters

save('model_jun18.mat','model');

figure(1)

%oob classification error
subplot(1,2,1)
plot(oobError(model))
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Classification Error')


gca = subplot(1,2,2);
bar(model.OOBPermutedVarDeltaError)
xlabel('Feature Index')
ylabel('Out-of-Bag Feature Importance')
set(gca,'XTickLabels',T.Properties.VariableNames); 
