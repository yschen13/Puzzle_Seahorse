close all;clear;

cd('~/Documents/Puzzle/')

% Input the pattern, each row is edges of one card, clockwise circular
% pattern code: *0: tail; *1:head
% pattern code: 1* orange; 2* green; 3* white; 4* red

Card = [11 31 40 21;
	30 41 20 10;
	41 41 10 31;
	30 11 20 41;
	40 31 11 21;
	30 20 11 21;
	41 31 31 10;
	41 20 11 30;
	21 11 40 21];


length(find(mod(Card(:),10)==0)) % number of tails
length(find(mod(Card(:),10)==1)) % number of heads

sum(round(Card(:)/10)==1) % orange halves
sum(round(Card(:)/10)==2) % green halves
sum(round(Card(:)/10)==3) % white halves
sum(round(Card(:)/10)==4) % red halves


% find the center card
Pos = NaN(3,3);
% Pos(2,2) = 1;
% Pos(2,2) = 2;
% Pos(2,2) = 3;
% Pos(2,2) = 4;
% Pos(2,2) = 5;
% Pos(2,2) = 6;
% Pos(2,2) = 7;
% Pos(2,2) = 8;
Pos(2,2) = 9;
Pos_pre = Pos;

TargetPattern_up = 10*round(Card(Pos(2,2),1)/10) + (1-mod(Card(Pos(2,2),1),10));
[idx_r_up,idx_c_up] = find(Card==TargetPattern_up);
TargetPattern_rt = 10*round(Card(Pos(2,2),2)/10) + (1-mod(Card(Pos(2,2),2),10));
[idx_r_rt,idx_c_rt] = find(Card==TargetPattern_rt);
TargetPattern_down = 10*round(Card(Pos(2,2),3)/10) + (1-mod(Card(Pos(2,2),3),10));
[idx_r_down,idx_c_down] = find(Card==TargetPattern_down);
TargetPattern_lt = 10*round(Card(Pos(2,2),4)/10) + (1-mod(Card(Pos(2,2),4),10));
[idx_r_lt,idx_c_lt] = find(Card==TargetPattern_lt);

Card_upright = Card; 

Match4 = 0;Pos4 = {}; Card_upright4 = {};
for k_up = 1:length(idx_r_up)
	Pos = Pos_pre; CardSelect = Pos(~isnan(Pos));
	if any(CardSelect==idx_r_up(k_up))
		continue
	else
		CardSelect(2) = idx_r_up(k_up); Pos(1,2) = idx_r_up(k_up);
		Card_upright(Pos(1,2),:) = circshift(Card(Pos(1,2),:),3-idx_c_up(k_up));
		for k_rt = 1:length(idx_r_rt)
			if any(CardSelect == idx_r_rt(k_rt)) 
				continue
			else
				CardSelect(3) = idx_r_rt(k_rt); Pos(2,3) = idx_r_rt(k_rt);	
				Card_upright(Pos(2,3),:) = circshift(Card(Pos(2,3),:),4-idx_c_rt(k_rt));
				% test Pos(1,3)
				LowerPattern = Card_upright(Pos(2,3),1);
				LeftPattern = Card_upright(Pos(1,2),2);
				constrain = [10*round(LowerPattern/10) + (1-mod(LowerPattern,10))
							10*round(LeftPattern/10) + (1-mod(LeftPattern,10))];
				% check whether the remaining cards satisfy constrains
				[row,col] = find(Card==constrain(1));
				for k_13 = 1:length(row)
					if any(CardSelect==row(k_13))
						continue
					else
						tmp = mod(col(k_13)+1,4);
						if tmp==0
							tmp=4;
						end
						if Card(row(k_13),tmp) == constrain(2)
							CardSelect(4) = row(k_13); Pos(1,3) = row(k_13);
							Match4 = Match4 + 1; 
							Pos4 = [Pos4 {Pos}]; Card_upright4 = [Card_upright4 {Card_upright}];
						end
					end
				end
			end
			['Searched Pos(2,3): ' num2str(k_rt) '/' num2str(length(idx_r_rt))]
		end
		['Searched Pos(1,2): ' num2str(k_up) '/' num2str(length(idx_r_up))]
	end
end


% Second round search to the left right corner
Match6 = 0; Pos6 = {}; Card_upright6 = {};
for idx_pos = 1:length(Pos4)
	Pos = Pos4{idx_pos}; CardSelect = Pos(~isnan(Pos));
	Card_upright = Card_upright4{idx_pos};
	for k_lt = 1:length(idx_r_lt)
		if any(CardSelect==idx_r_lt(k_lt))
			continue
		else
			CardSelect(5) = idx_r_lt(k_lt); Pos(2,1) = idx_r_lt(k_lt);
			Card_upright(Pos(2,1),:) = circshift(Card(Pos(2,1),:),2-idx_c_lt(k_lt));
			% test Pos(1,1)
			Pattern1 = Card_upright(Pos(1,2),4); % match to the right
			Pattern2 = Card_upright(Pos(2,1),1); % match to the lower
			constrain = [10*round(Pattern1/10) + (1-mod(Pattern1,10))
						10*round(Pattern2/10) + (1-mod(Pattern2,10))];
			[row,col] = find(Card==constrain(1));
			for k_11 = 1:length(row)
				if any(CardSelect==row(k_11))
					continue
				else
					tmp = mod(col(k_11)+1,4);
					if tmp==0
						tmp=4;
					end
					if Card(row(k_11),tmp) == constrain(2)
						Pos(1,1) = row(k_11);
						Match6 = Match6 + 1; Pos6 = [Pos6 {Pos}];
						Card_upright6 = [Card_upright6 {Card_upright}];
					end
				end
			end
		end
		['Searched Pos(2,1): ' num2str(k_lt) '/' num2str(length(idx_r_lt))]
	end
	['Searched Match4 Pattern: ' num2str(idx_pos) '/' num2str(length(Pos4))]
end




% third round search of the right lower corner
Match8 = 0; Pos8 = {}; Card_upright8 = {};
for idx_pos = 1:length(Pos6)
	Pos = Pos6{idx_pos}; CardSelect = Pos(~isnan(Pos));
	Card_upright = Card_upright6{idx_pos};
	for k_down = 1:length(idx_r_down)
		if any(CardSelect==idx_r_down(k_down))
			continue
		else
			CardSelect(7) = idx_r_down(k_down); Pos(3,2) = idx_r_down(k_down);
			Card_upright(Pos(3,2),:) = circshift(Card(Pos(3,2),:),1-idx_c_down(k_down));
			% test Pos (3,3)
			Pattern1 = Card_upright(Pos(3,2),2); % matched to the left
			Pattern2 = Card_upright(Pos(2,3),3); % matched to the top
			constrain = [10*round(Pattern1/10) + (1-mod(Pattern1,10))
						10*round(Pattern2/10) + (1-mod(Pattern2,10))];
			[row,col] = find(Card==constrain(1));
			for k_33 = 1:length(row)
				if any(CardSelect==row(k_33))
					continue
				else
					tmp = mod(col(k_33)+1,4);
					if tmp==0
						tmp=4;
					end
					if Card(row(k_33),tmp) == constrain(2)
						['Matched']
						Pos(3,3) = row(k_33);
						Match8 = Match8 + 1;
						Pos8 = [Pos8 {Pos}];
						Card_upright8 = [Card_upright8 {Card_upright}];
					end
				end
			end
		end
		['Searched Pos(3,2): ' num2str(k_down) '/' num2str(length(idx_r_down))]
	end
	['Searched Match6 Pattern: ' num2str(idx_pos) '/' num2str(length(Pos6))]
end


% test for lower right corner
for idx_pos = 1:length(Pos8)
	Pos = Pos8{idx_pos};
	Pattern1 = Card_upright(Pos(2,1),3); % matched to the top
	Pattern2 = Card_upright(Pos(3,2),4); % matched to the right
	constrain = [10*round(Pattern1/10) + (1-mod(Pattern1,10))
				10*round(Pattern2/10) + (1-mod(Pattern2,10))]
	RemainCard = setdiff(1:9,unique(Pos(:)));
	Card(RemainCard,:)
end
Pos(3,1) = RemainCard;
