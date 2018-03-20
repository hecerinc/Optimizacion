% Knapsack
% @version 1.0
% @author Hector Rincon
% @desc My own implementation of the knapsack 1/0 problem
% 		knapsackMain is a version using heuristics
% 		knapsack2 uses hyperheuristics

% knapsackMain
function [knapsack] = knapsackMain(knapsack,items, heuristicID)
	while ~isempty(items)
		itemID = selectItemKP(items, heuristicID);
		[knapsack, items, exFlag] = storeKPItem(knapsack, items, itemID);
		knapsack = knapsackFitness(knapsack);
	end
	disp(knapsack(1).items)
end



% knapsackMain (with hyperheuristics)
function [knapsack] = knapsack2(knapsack, items, rules, actions, featureIDs)
	while ~isempty(items)

		featureCalcs = getKPFeatures(items, featureIDs);

		% Get eucledian distance
		euclid = getEuclid(featureCalcs, rules);

		% Get heuristic to apply
		[~, minpos] = min(euclid);

		itemID = selectItemKP(items, actions(minpos));
		[knapsack, items, exFlag] = storeKPItem(knapsack, items, itemID);

		knapsack = knapsackFitness(knapsack);
	end

end



% updateKP
function [knapsack, itemsKP] = updateKP(knapsack, itemsKP, itemID)
    knapsack(1).items = [knapsack(1).items; itemsKP(itemID,:)];
    knapsack(1).freeCapacity = knapsack(1).freeCapacity - itemsKP(itemID, 1);
    % remove from itemsKP
    itemsKP = [itemsKP(1:itemID-1, :); itemsKP(itemID+1:end, :)];
end

% storeKPItem    
function [knapsack, itemsKP, exFlag] = storeKPItem(knapsack, itemsKP, itemID)
    exFlag = -1;
    if knapsack(1).freeCapacity >= itemsKP(itemID,1)
        [knapsack, itemsKP] = updateKP(knapsack, itemsKP, itemID);
        exFlag = 0;
	else
		% Get it out of the items list
		itemsKP = [itemsKP(1:itemID-1, :); itemsKP(itemID+1:end, :)];
    end
end


% 1:  Default.  
% 2:  Max  Profit.  
% 3:  Max  Profit per Weight. 
% 4:  Min Weight.

% selectItemKP
function [itemID] = selectItemKP(items, HeuristicID)
	switch HeuristicID
		case 1 % Default
			itemID = 1;
		case 2 % Max Profit
			% profit lies in second col
			[~, itemID] = max(items(:, 2));
		case 3 % Max profit per weight
			[~, itemID] = max(items(:,2)./items(:,1));
		case 4 % Min weight
			[~, itemID] = min(items(:, 1));
	end
end




% getKPFeatures


% FEATURES:
% 1. Promedio normalizado del peso
% 2. Mediana normalizada del peso
% 3. Desviacion estandar del peso
% 4. Promedio normalizado del profit
% 4. Mediana normalizada del profit
% 6. Desviacion estandar del profit
% 7. Correlacion normalizada entre el peso y el profit


function [featureVec] = getKPFeatures(items, featureIDs)
	featureFuncs = @(items)[...
		mean(items(:,1))/max(items(:,1)),	... % promedio normalizado
		median(items(:,1))/max(items(:,1)), ... % mediana normalizada
		std(items(:, 1)),					... % desviacion estandar del peso
		mean(items(:, 2))/max(items(:, 2)), ... % promedio normalizado del profit
		median(items(:,2))/max(items(:,2)),	... % mediana normalizada del profit
		std(items(:,2)),					... % desviacion estandar del profit
		corr(items(:, 1), items(:, 2))		... % correlacion normalizada entre el peso y el profit
	];
	featureVec = featureFuncs(items);
	featureVec = featureVec(featureIDs);
end


% knapsackFitness
% fitness: profit
function [knapsack] = knapsackFitness(knapsack)
	knapsack(1).profit = sum(knapsack(1).items(:, 2));
	knapsack(1).weight = sum(knapsack(1).items(:, 1));
	knapsack(1).freeCapacity = knapsack(1).maxWeight - knapsack(1).weight;
	knapsack(1).isValid = knapsack(1).freeCapacity >= 0;
end

function euclid = getEuclid(f, F)
	euclid = [];
	for i=1:length(F)
		euclid = [euclid; norm(F(i,:) - f)];
	end
end





