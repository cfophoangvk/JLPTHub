<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.time.Year" %>
    <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
        <layout:mainLayout>
            <section class="relative pb-20 lg:pt-40 lg:pb-28 overflow-hidden">
                <div class="absolute inset-0 hero-pattern -z-10"></div>
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
                    <div class="grid lg:grid-cols-2 gap-12 items-center">
                        <div class="text-center lg:text-left">
                            <div
                                class="inline-block px-4 py-1.5 mb-6 rounded-full bg-rose-100 text-brand-red font-semibold text-sm">
                                🚀 Nền tảng luyện thi JLPT uy tín
                            </div>
                            <h1 class="text-4xl lg:text-5xl font-extrabold text-slate-900 leading-tight mb-6">
                                Chinh phục tiếng Nhật <br>
                                <span class="text-brand-red">Từ N5 đến N1</span>
                            </h1>
                            <p class="text-lg text-slate-600 mb-8 max-w-2xl mx-auto lg:mx-0">
                                Hệ thống thi thử mô phỏng 100% đề thật, lộ trình học cá nhân hóa và kho từ vựng
                                Flashcard thông minh. Giúp bạn tự tin đỗ JLPT ngay lần thi đầu tiên.
                            </p>
                            <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                                <a href="${pageContext.request.contextPath}/auth/login"
                                    class="bg-rose-400 hover:bg-rose-700 text-white text-lg px-8 py-4 rounded-full font-bold transition shadow-xl shadow-rose-500/30">
                                    Bắt đầu ôn luyện
                                </a>
                            </div>
                        </div>

                        <div class="relative mx-auto w-full max-w-lg lg:max-w-full">
                            <div class="relative rounded-2xl bg-slate-900 shadow-2xl p-2 border-4 border-slate-100">
                                <div class="bg-slate-800 rounded-xl overflow-hidden">
                                    <div
                                        class="flex items-center gap-2 px-4 py-3 bg-slate-900 border-b border-slate-700">
                                        <div class="w-3 h-3 rounded-full bg-red-500"></div>
                                        <div class="w-3 h-3 rounded-full bg-yellow-500"></div>
                                        <div class="w-3 h-3 rounded-full bg-green-500"></div>
                                    </div>
                                    <div class="p-6">
                                        <div class="flex justify-between items-end mb-6">
                                            <div>
                                                <p class="text-slate-400 text-sm">Tiến độ</p>
                                                <h3 class="text-white text-2xl font-bold">85% Hoàn thành</h3>
                                            </div>
                                            <span class="text-green-400 font-bold">+12% tuần này</span>
                                        </div>
                                        <div class="h-32 flex items-end justify-between gap-2">
                                            <div
                                                class="w-full bg-slate-700 rounded-t-sm h-1/3 hover:bg-rose-400 transition-colors">
                                            </div>
                                            <div
                                                class="w-full bg-slate-700 rounded-t-sm h-1/2 hover:bg-rose-400 transition-colors">
                                            </div>
                                            <div
                                                class="w-full bg-slate-700 rounded-t-sm h-2/3 hover:bg-rose-400 transition-colors">
                                            </div>
                                            <div
                                                class="w-full bg-rose-400 rounded-t-sm h-full shadow-[0_0_15px_rgba(225,29,72,0.5)]">
                                            </div>
                                            <div
                                                class="w-full bg-slate-700 rounded-t-sm h-3/4 hover:bg-rose-400 transition-colors">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div
                                class="absolute -top-10 -right-10 bg-white p-4 rounded-xl shadow-lg animate-bounce hidden md:block">
                                <span class="text-2xl">💮</span>
                                <span class="font-bold text-slate-800 ml-2">がんばって!</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-10 bg-slate-50 border-y border-slate-200">
                <div class="max-w-7xl mx-auto px-4 text-center">
                    <p class="text-slate-500 font-medium mb-6 uppercase tracking-wider text-sm">Hỗ trợ đầy đủ các cấp độ
                        JLPT</p>
                    <div class="flex flex-wrap justify-center gap-4 sm:gap-8">
                        <span
                            class="px-6 py-3 rounded-xl bg-white border border-slate-200 font-bold hover:border-rose-400 hover:text-rose-600 hover:bg-rose-200 cursor-pointer transition">N5</span>
                        <span
                            class="px-6 py-3 rounded-xl bg-white border border-slate-200 font-bold hover:border-rose-400 hover:text-rose-600 hover:bg-rose-200 cursor-pointer transition">N4</span>
                        <span
                            class="px-6 py-3 rounded-xl bg-white border border-slate-200 font-bold hover:border-rose-400 hover:text-rose-600 hover:bg-rose-200 cursor-pointer transition">N3</span>
                        <span
                            class="px-6 py-3 rounded-xl bg-white border border-slate-200 font-bold hover:border-rose-400 hover:text-rose-600 hover:bg-rose-200 cursor-pointer transition">N2</span>
                        <span
                            class="px-6 py-3 rounded-xl bg-white border border-slate-200 font-bold hover:border-rose-400 hover:text-rose-600 hover:bg-rose-200 cursor-pointer transition">N1</span>
                    </div>
                </div>
            </section>

            <section class="py-20 lg:py-28">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="text-center mb-16">
                        <h2 class="text-3xl md:text-4xl font-bold text-slate-900 mb-4">Tại sao chọn JLPTHub?</h2>
                        <p class="text-lg text-slate-600 max-w-2xl mx-auto">Chúng tôi không chỉ cung cấp đề thi, chúng
                            tôi mang đến một phương pháp học tập hiệu quả dựa trên dữ liệu.</p>
                    </div>

                    <div class="grid md:grid-cols-2 gap-8 mx-auto">
                        <div
                            class="bg-white p-8 rounded-2xl border border-slate-100 shadow-lg hover:shadow-xl transition group">
                            <div
                                class="w-14 h-14 bg-rose-100 rounded-xl flex items-center justify-center text-brand-red text-2xl mb-6 group-hover:scale-110 transition duration-300">
                                <i class="fa-solid fa-clock"></i>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 mb-3">Thi thử như thi thật</h3>
                            <p class="text-slate-600 leading-relaxed">Giao diện phòng thi mô phỏng 100% thực tế với đồng
                                hồ đếm ngược. Giúp bạn rèn luyện áp lực thời gian.</p>
                        </div>

                        <div
                            class="bg-white p-8 rounded-2xl border border-slate-100 shadow-lg hover:shadow-xl transition group">
                            <div
                                class="w-14 h-14 bg-amber-100 rounded-xl flex items-center justify-center text-amber-600 text-2xl mb-6 group-hover:scale-110 transition duration-300">
                                <i class="fa-solid fa-layer-group"></i>
                            </div>
                            <h3 class="text-xl font-bold text-slate-900 mb-3">Flashcard thông minh</h3>
                            <p class="text-slate-600 leading-relaxed">Học từ vựng với phương pháp Lặp lại ngắt quãng
                                (Spaced Repetition), giúp nhớ lâu hơn 300% so với cách học vẹt.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="py-20 bg-slate-900 text-white relative overflow-hidden">
                <div
                    class="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 rounded-full bg-rose-400 opacity-20 blur-3xl">
                </div>
                <div
                    class="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 rounded-full bg-blue-600 opacity-20 blur-3xl">
                </div>

                <div class="max-w-4xl mx-auto px-4 text-center relative z-10">
                    <h2 class="text-3xl md:text-5xl font-bold mb-6">Sẵn sàng chinh phục tấm bằng JLPT?</h2>
                    <p class="text-slate-300 text-lg mb-10">Tham gia cùng 2000+ học viên đang ôn luyện mỗi ngày trên
                        JLPTHub.</p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <a href="${pageContext.request.contextPath}/auth/register"
                            class="bg-rose-400 hover:bg-rose-700 text-white text-lg px-10 py-4 rounded-full font-bold transition shadow-lg shadow-rose-900/50">
                            Đăng ký tài khoản miễn phí
                        </a>
                    </div>
                </div>
            </section>

            <footer class="bg-white border-t border-slate-200 pt-16 pb-8">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
                        <div class="col-span-1 md:col-span-1">
                            <div class="flex items-center mb-4">
                                <span class="text-brand-red text-2xl mr-2"><i class="fa-solid fa-torii-gate"></i></span>
                                <span class="font-bold text-xl text-slate-900">JLPTHub</span>
                            </div>
                            <p class="text-slate-500 text-sm leading-relaxed">
                                Nền tảng ôn luyện thi tiếng Nhật trực tuyến hàng đầu, giúp bạn rút ngắn thời gian ôn tập
                                và đạt điểm cao.
                            </p>
                        </div>
                        <div>
                            <h4 class="font-bold text-slate-900 mb-4">Sản phẩm</h4>
                            <ul class="space-y-2 text-sm text-slate-600">
                                <li><a href="#" class="hover:text-brand-red">Thi thử JLPT</a></li>
                                <li><a href="#" class="hover:text-brand-red">Học từ vựng</a></li>
                                <li><a href="#" class="hover:text-brand-red">Luyện nghe</a></li>
                                <li><a href="#" class="hover:text-brand-red">Kanji Master</a></li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="font-bold text-slate-900 mb-4">Tài nguyên</h4>
                            <ul class="space-y-2 text-sm text-slate-600">
                                <li><a href="#" class="hover:text-brand-red">Blog chia sẻ</a></li>
                                <li><a href="#" class="hover:text-brand-red">Kinh nghiệm thi</a></li>
                                <li><a href="#" class="hover:text-brand-red">Tài liệu miễn phí</a></li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="font-bold text-slate-900 mb-4">Liên hệ</h4>
                            <ul class="space-y-2 text-sm text-slate-600">
                                <li class="flex gap-4 mt-4">
                                    <a href="https://www.facebook.com/forger.anya.416352" class="text-xl"><i
                                            class="fa-brands fa-facebook text-blue-600"></i></a>
                                    <a href="https://www.tiktok.com/@cfopvkh2004" class="text-xl"><i
                                            class="fa-brands fa-tiktok"></i></a>
                                    <a href="https://www.youtube.com/@cfop_hoangvk" class="text-xl"><i
                                            class="fa-brands fa-youtube text-red-500"></i></a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="border-t border-slate-100 pt-8 text-center text-slate-500 text-sm">
                        &copy; ${Year.now()} JLPTHub. All rights reserved.
                    </div>
                </div>
            </footer>
        </layout:mainLayout>