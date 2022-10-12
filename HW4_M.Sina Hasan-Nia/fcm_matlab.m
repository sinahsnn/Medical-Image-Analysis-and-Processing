function [centers, U] = fcm_matlab(data, cluster_numbers, q,initial_w);
datar = reshape(data,200,256,4);
u = zeros(200,256,cluster_numbers);
w = initial_w;
for counter = 1:100
    w_old = w;
    den_all = zeros(200,256);
    for i = 1:200
        for j = 1:256
           for k = 1:cluster_numbers
               temp = reshape(datar(i,j,:),1,4);
               den_all(i,j) = den_all(i,j) + (1/(norm(temp - w(k,:))).^(2/(q-1)));
           end
        end
    end
    for k = 1:cluster_numbers
        for i = 1:200
            for j = 1:256
                temp1 = reshape(datar(i,j,:),1,4);
                temp = (1/(norm(temp1 - w(k,:))).^(2/(q-1)));
                u(i,j,k) = temp/den_all(i,j);
            end
        end
    end
    for k = 1:cluster_numbers
        uu = u(:,:,k);

        for j = 1:4
            num = sum(sum((uu.^q).*(datar(:,:,j))));
            den = sum(sum(uu.^q));
            w(k,j) = num/den;
        end
    end
    if (sum(sum((w-w_old).^2)) < 0.0001)
        break
    end

end
centers = w;
U = u;
disp(['code ended at iteration = ' num2str(counter)]);