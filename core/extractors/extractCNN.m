function F=extractCNN(img, net)
    arguments
        img
        net = alexnet
    end

    img = imresize(img, 'OutputSize', net.Layers(1).InputSize(1:2));

    F = activations(net, img, 'fc7');

    F = reshape(F, [1, length(F)]);
return;
