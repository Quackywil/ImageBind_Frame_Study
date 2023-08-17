try
    for trial=1:3
        % Draw random time
        randTime = randi(3);

        % Instruct to press key
        clc
        display('Press the left arrow or right arrow')

        % Read keyboard
        [secs, keys] = KbWait;

        % Get key that was pressed
        key = find(keys);


        % Identify key pressed
        if key == 69
            resp = 0;    % Let's arbitrarily decide that a resp "0" Right Arrow
        else if key == 70
               resp = 1; % Let's arbitrarily decide that a resp "1" Left Arrow
        else
            resp = -1;
        end



        