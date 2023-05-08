function x = errorHandler(x)

    % Depending on the input value, returns an appropriate error message.
    % Tests for non-integer or negative values.
    % Put into the following loop construct, this code can accomodate for
    % re-entries:
    %
    %     while ((mod(x,1) ~= 0) || (x <= 0) )
    %         fprintf("Input: ")
    %         x = errorHandler(x);
    %     end
    %

    neg_ct = 0;
    int_ct = 0;
    x = input('');
    if (mod(x,1) ~= 0)
        int_ct = int_ct + 1;
    elseif (x <= 0)
        neg_ct = neg_ct + 1;
    end
    if (int_ct == 1 || neg_ct == 1)
        fprintf("\nERROR: Please enter a")
        if (int_ct == 1)
            fprintf("n integer value")
        else
            fprintf(" non-negative value")
        end
    end
    fprintf("\n")