<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layout" %>
            <%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>

                <layout:mainLayout>
                    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
                        <div class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-40">
                            <div class="max-w-5xl mx-auto px-6 py-4">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h1 class="text-xl font-bold text-gray-900">${test.title}</h1>
                                        <p class="text-gray-600 text-sm">Cấp độ: ${test.level}</p>
                                    </div>
                                    <div class="flex items-center space-x-4">
                                        <div id="timer" class="flex items-center bg-indigo-100 px-4 py-2 rounded-lg">
                                            <i class="fa-solid fa-clock text-indigo-600 mr-2"></i>
                                            <span id="timer-display"
                                                class="font-mono font-bold text-indigo-700">00:00</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white border-b border-gray-200 sticky top-[72px] z-30">
                            <div class="max-w-5xl mx-auto px-6">
                                <div class="flex space-x-1" id="section-tabs">
                                    <c:forEach var="section" items="${sections}" varStatus="status">
                                        <button type="button" id="tab-${status.index}" class="section-tab px-6 py-3 font-medium text-sm rounded-t-lg transition-colors ${status.index == 0 ? 'bg-indigo-500 text-white' : 'bg-gray-100 text-gray-600'}">
                                            <c:choose>
                                                <c:when test="${section.sectionType == 'Moji/Goi'}">
                                                    <i class="fa-solid fa-language mr-2"></i>
                                                </c:when>
                                                <c:when test="${section.sectionType == 'Bunpou'}">
                                                    <i class="fa-solid fa-spell-check mr-2"></i>
                                                </c:when>
                                                <c:when test="${section.sectionType == 'Choukai'}">
                                                    <i class="fa-solid fa-headphones mr-2"></i>
                                                </c:when>
                                            </c:choose>
                                            ${section.sectionType}
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <form id="testForm" action="${pageContext.request.contextPath}/test/submit" method="POST">
                            <input type="hidden" name="testId" value="${test.id}" />
                            <input type="hidden" name="duration" id="durationInput" value="0" />

                            <div class="max-w-5xl mx-auto px-6 py-8">
                                <c:forEach var="section" items="${sections}" varStatus="sectionStatus">
                                    <div id="section-${sectionStatus.index}"
                                        class="section-content ${sectionStatus.index == 0 ? '' : 'hidden'}">

                                        <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
                                            <div class="flex items-center justify-between">
                                                <div>
                                                    <h2 class="text-2xl font-bold text-gray-900">${section.sectionType}
                                                    </h2>
                                                    <p class="text-gray-600">
                                                        <i class="fa-solid fa-clock mr-1"></i>
                                                        Thời gian: ${section.timeLimitMinutes} phút
                                                    </p>
                                                </div>
                                                <div class="text-right">
                                                    <p class="text-sm text-gray-500">Điểm đạt:
                                                        ${section.passScore}/${section.totalScore}</p>
                                                </div>
                                            </div>

                                            <c:if
                                                test="${section.sectionType == 'Choukai' && not empty section.audioUrl}">
                                                <audio id="audio-${sectionStatus.index}" src="${section.audioUrl}"
                                                    preload="auto" style="display: none;"></audio>
                                            </c:if>
                                        </div>

                                        <c:set var="questions" value="${sectionQuestions[section.id]}" />
                                        <c:forEach var="question" items="${questions}" varStatus="qStatus">
                                            <div class="bg-white rounded-xl shadow-lg p-6 mb-4 question-card">
                                                <div class="flex items-start mb-4">
                                                    <span
                                                        class="flex-shrink-0 w-8 h-8 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center font-bold text-sm mr-3">
                                                        ${qStatus.index + 1}
                                                    </span>
                                                    <div class="flex-1">
                                                        <p class="text-gray-900 font-medium text-lg">${question.content}
                                                        </p>
                                                        <c:if test="${not empty question.imageUrl}">
                                                            <img src="${question.imageUrl}"
                                                                class="mt-3 rounded-lg max-h-48 object-contain"
                                                                alt="Question image" />
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <div class="space-y-3 ml-11">
                                                    <c:set var="options"
                                                        value="${questionOptions[section.id][question.id]}" />
                                                    <c:forEach var="option" items="${options}" varStatus="optStatus">
                                                        <label
                                                            class="flex items-center p-4 rounded-lg border-2 border-gray-200 hover:border-indigo-300 hover:bg-indigo-50 cursor-pointer transition-all option-label">
                                                            <input type="radio" name="question_${question.id}"
                                                                value="${option.id}" class="hidden peer" />
                                                            <span
                                                                class="w-6 h-6 rounded-full border-2 border-gray-300 flex items-center justify-center mr-3 peer-checked:border-indigo-500 peer-checked:bg-indigo-500 transition-colors">
                                                                <span
                                                                    class="w-2 h-2 rounded-full bg-white opacity-0 peer-checked:opacity-100"></span>
                                                            </span>
                                                            <span class="flex-1 text-gray-700">${option.content}</span>
                                                            <c:if test="${not empty option.imageUrl}">
                                                                <img src="${option.imageUrl}"
                                                                    class="ml-3 rounded max-h-16 object-contain"
                                                                    alt="Option image" />
                                                            </c:if>
                                                        </label>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <div class="flex justify-end items-center mt-8">
                                            <c:choose>
                                                <c:when test="${sectionStatus.index < sections.size() - 1}">
                                                    <button type="button"
                                                        onclick="openDialog('complete-section-confirm')"
                                                        class="px-6 py-3 bg-indigo-500 hover:bg-indigo-600 text-white font-medium rounded-lg transition-colors">
                                                        Hoàn thành
                                                        <i class="fa-solid fa-arrow-right ml-2"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" onclick="confirmSubmit()"
                                                        class="px-8 py-3 bg-green-500 hover:bg-green-600 text-white font-bold rounded-lg transition-colors">
                                                        <i class="fa-solid fa-paper-plane mr-2"></i>
                                                        Nộp bài
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </form>
                            
                        <ui:alertDialog id="complete-section-confirm">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận hoàn thành</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn hoàn thành phần thi?<br />
                                        <span class="text-amber-600 font-semibold">Không thể quay lại phần thi này.</span>
                                    </div>
                                </ui:alertDialogDescription>
                            </ui:alertDialogHeader>
                            <ui:alertDialogFooter>
                                <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                                <ui:alertDialogAction onclick="nextSection();closeDialog(this);">
                                    Phần tiếp theo
                                </ui:alertDialogAction>
                            </ui:alertDialogFooter>
                        </ui:alertDialog>

                        <ui:alertDialog id="submit-confirm">
                            <ui:alertDialogHeader>
                                <ui:alertDialogTitle>Xác nhận nộp bài</ui:alertDialogTitle>
                                <ui:alertDialogDescription>
                                    <div class="text-center text-muted-foreground">
                                        Bạn có chắc chắn muốn nộp bài?<br />
                                        <span class="text-amber-600 font-semibold">Sau khi nộp bạn sẽ không thể sửa đổi
                                            câu trả lời.</span>
                                    </div>
                                </ui:alertDialogDescription>
                            </ui:alertDialogHeader>
                            <ui:alertDialogFooter>
                                <ui:alertDialogCancel>Hủy</ui:alertDialogCancel>
                                <ui:alertDialogAction onclick="submitAnswers()">
                                    Nộp bài
                                </ui:alertDialogAction>
                            </ui:alertDialogFooter>
                        </ui:alertDialog>
                    </div>

                    <script>
                        let startTime = Date.now();
                        let currentSection = 0;
                        const totalSections = ${ sections.size()};

                        // Timer
                        function updateTimer() {
                            const elapsed = Math.floor((Date.now() - startTime) / 1000);
                            const minutes = Math.floor(elapsed / 60);
                            const seconds = elapsed % 60;
                            document.getElementById('timer-display').textContent =
                                String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
                            document.getElementById('durationInput').value = elapsed;
                        }
                        setInterval(updateTimer, 1000);

                        function nextSection() {
                            //Disable nút section vừa làm
                            document.getElementById('tab-' + currentSection).disabled = true;
                            document.getElementById('tab-' + currentSection).classList.add('cursor-not-allowed');
                            currentSection++;
                            
                            const allAudios = document.querySelectorAll('audio');
                            allAudios.forEach(audio => {
                                audio.pause();
                                audio.currentTime = 0;
                            });

                            document.querySelectorAll('.section-content').forEach(el => el.classList.add('hidden'));
                            document.querySelectorAll('.section-tab').forEach(el => {
                                el.classList.remove('bg-indigo-500', 'text-white');
                                el.classList.add('bg-gray-100', 'text-gray-600');
                            });

                            document.getElementById('section-' + currentSection).classList.remove('hidden');
                            const tab = document.getElementById('tab-' + currentSection);
                            tab.classList.remove('bg-gray-100', 'text-gray-600');
                            tab.classList.add('bg-indigo-500', 'text-white');

                            const audio = document.getElementById('audio-' + currentSection);
                            if (audio) {
                                audio.play().catch(e => console.log('Audio autoplay blocked:', e));
                            }

                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }

                        function confirmSubmit() {
                            openDialog('submit-confirm');
                        }

                        document.querySelectorAll('.option-label input[type="radio"]').forEach(radio => {
                            radio.addEventListener('change', function () {
                                const parent = this.closest('.space-y-3');
                                parent.querySelectorAll('.option-label').forEach(label => {
                                    label.classList.remove('border-indigo-500', 'bg-indigo-50');
                                    label.classList.add('border-gray-200');
                                });

                                // Add selected style
                                const label = this.closest('.option-label');
                                label.classList.remove('border-gray-200');
                                label.classList.add('border-indigo-500', 'bg-indigo-50');
                            });
                        });

                        function saveAnswers() {
                            const formData = new FormData(document.getElementById('testForm'));
                            const answers = {};
                            for (let [key, value] of formData.entries()) {
                                if (key.startsWith('question_')) {
                                    answers[key] = value;
                                }
                            }
                            localStorage.setItem('test_${test.id}_answers', JSON.stringify(answers));
                        }

                        function restoreAnswers() {
                            const saved = localStorage.getItem('test_${test.id}_answers');
                            if (saved) {
                                const answers = JSON.parse(saved);
                                for (let [key, value] of Object.entries(answers)) {
                                    const radio = document.querySelector('input[name="' + key + '"][value="' + value + '"]');
                                    if (radio) {
                                        radio.checked = true;
                                        radio.dispatchEvent(new Event('change'));
                                    }
                                }
                            }
                        }

                        setInterval(saveAnswers, 10000);

                        document.addEventListener('DOMContentLoaded', restoreAnswers);

                        function submitAnswers() {
                            localStorage.removeItem('test_${test.id}_answers');
                            submitForm('testForm');
                        }
                    </script>
                </layout:mainLayout>