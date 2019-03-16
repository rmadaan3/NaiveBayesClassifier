filename = input('Enter file name:','s');
flag = 1;
if strcmp(filename , "balance-scale.data") 
    Q = importdata(filename);
    Train = [Q.textdata string(Q.data)];
elseif strcmp(filename , "adult+stretch.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(5) R(1:4)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "adult-stretch.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(5) R(1:4)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "yellow-small+adult-stretch.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(5) R(1:4)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "yellow-small.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(5) R(1:4)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "kr-vs-kp.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(37) R(1:36)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "car.data")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,','));
        X = [R(7) R(1:6)];
        C = [C; X];
    end
    Train = C;
elseif strcmp(filename , "lenses.data")
    Q = importdata(filename);
    C = string(Q(:,2:6));
    Train = [C(:,5) C(:,1:4)];
elseif strcmp(filename , "lymphography.data")
    Q = importdata(filename);
    Train = string(Q);
elseif strcmp(filename , "monks-1.train")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Train = C;
    Q = importdata('monks-1.test');
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Test = C;
    flag = 2 ;
elseif strcmp(filename , "monks-2.train")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Train = C;
    Q = importdata('monks-2.test');
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Test = C;
    flag = 2 ;
elseif strcmp(filename , "monks-3.train")
    Q = importdata(filename);
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Train = C;
    Q = importdata('monks-3.test');
    C = [];
    for D=1:size(Q,1)
        W = Q{D,1};
        R = string(strsplit(W,' '));
        C = [C; R(2:8)];
    end
    Test = C;
    flag = 2 ;
elseif strcmp(filename , "hayes-roth.data")
    Q = importdata(filename);
    C = string(Q(:,2:6));
    Train = [C(:,5) C(:,1:4)];
    Q = importdata('hayes-roth.test');
    Test = string([Q(:,5) Q(:,1:4)]);
    flag = 2;
elseif strcmp(filename , "shuttle-landing-control.data")
    Q = importdata(filename);
    Train = [string(Q.textdata) string(Q.data)];
    flag = 3;
end

B = array2table(Train(:,1));
T = table2array(B);
Lh = containers.Map();
for j = 2:size(Train,2)
    if ~flag==3    
        for k = 1:size(Train,1)
            a = strcat(Train{k,1}, int2str(j), Train{k,j});
            a = char(a);
            if ~isKey(Lh , a)
                Lh(a) = 1;
            else 
                Lh(a) = Lh(a) + 1;
            end
        end
    else
        Star = ones(1,2);
        for k = 1:size(Train,1)
            if strcmp(Train{k,j} , '*')
                if ~strcmp(Train{k,1} , '1')
                    Star(2) = Star(2) + 1 ;
                else
                    Star(1) = Star(1) + 1 ;
                end
            end
        end
        for k = 1:size(Train,1)
            a = strcat(Train{k,1}, int2str(j), Train{k,j});
            a = char(a);
            if isKey(Lh , a)
                Lh(a) = Lh(a) + 1;
            elseif strcmp(Train(k,1), '1') 
                Lh(a) = Star(1);
            else
                Lh(a) = Star(2);
            end
        end
    end
end

Lh_keys = keys(Lh) ;
Lh_values = values(Lh);

Pr = containers.Map();
for i = 1 : size(Train,1)
    A = char(T{i,1});
    if ~isKey(Pr,A)
        Pr(A) = 1 ;
    else 
        Pr(A) = Pr(A) + 1 ;
    end
end
Pr_keys = keys(Pr);

Count = 0 ;
if flag == 1 || flag == 3   
    for i = 1:size(Train,1)
        X = length(Pr_keys);
        Probs = ones(1,X);
        for k = 1:X
            for j = 2:size(Train,2)
                a = strcat(Pr_keys{k}, int2str(j), Train{i,j});
                a = char(a);
                if flag == 3 && strcmp(Train{i,j},'*')
                    continue
                elseif ~isKey(Lh , a)
                    Probs(k) = Probs(k) * 0 ;
                else 
                    if ~strcmp(Pr_keys{k},char(Train{i,1}))
                       Probs(k) = Probs(k)*(Lh(a))/(Pr(Pr_keys{k}));
                    else
                        Probs(k) = Probs(k)*(Lh(a)-1)/(Pr(Pr_keys{k})-1);
                    end
                end            
            end
            if ~strcmp(Pr_keys{k},char(Train{i,1}))
                Probs(k) = (Probs(k) * Pr(Pr_keys{k}))/((size(Train,1))-1); 
            else
                Probs(k) = Probs(k)*((Pr(Pr_keys{k}))-1)/((size(Train,1))-1);
            end
        end
        [MaxValue,Index] = max(Probs);
        F = Pr_keys{Index};
        G = char(Train{i,1});
        if strcmp(F,G)
            Count = Count + 1 ;
        end
    end
    disp((Count/size(Train,1))*100);
else
    for i = 1:size(Test,1)
        X = length(Pr_keys);
        Probs = ones(1,X);
        for k = 1:X
            for j = 2:size(Test,2)
                a = strcat(Pr_keys{k}, int2str(j), Test{i,j});
                a = char(a);
                if ~isKey(Lh , a)
                    Probs(k) = Probs(k) * 0 ;
                else
                    Probs(k) = Probs(k)*(Lh(a))/(Pr(Pr_keys{k}));
                end
            end
            Probs(k) = Probs(k) * Pr(Pr_keys{k})/size(Test,1);
        end
        [MaxValue,Index] = max(Probs);
        F = Pr_keys{Index};
        G = char(Test{i,1});
        if strcmp(F,G)
            Count = Count + 1 ;
        end
    end
    disp((Count/size(Test,1))*100);
end