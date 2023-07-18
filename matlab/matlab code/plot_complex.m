function [] = plot_complex(input_sig,figure_num)

figure(figure_num);
clf(figure_num);
hold on;
plot(real(input_sig));
plot(imag(input_sig));
plot(abs(input_sig));
legend("real", "imag", "abs");
hold off;

end